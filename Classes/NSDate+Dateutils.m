//  NSDate+Dateutils.m
//
//  Created by frank on 5/25/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.

#import "NSDate+Dateutils.h"

@implementation NSDate (Dateutils)

// [NSCalendar currentCalendar] is extremely slow, but also not thread safe.
// This caches it per thread.
- (NSCalendar*) fod_currentCalendarForThread {
    NSCalendar *result = [[NSThread currentThread] threadDictionary][@"com.frankodwyer.NSCalendar.currentCalendar"];
    if (!result) {
        result = [NSCalendar currentCalendar];
        [[NSThread currentThread] threadDictionary][@"com.frankodwyer.NSCalendar.currentCalendar"] = result;
    }
    return result;
}

-(NSDate*) fod_startOfDay {
    NSCalendar *cal = [self fod_currentCalendarForThread];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSTimeZoneCalendarUnit)
                                          fromDate:self];
    return [cal dateFromComponents:components];
}

-(NSDate*) fod_dateByAddingDays:(NSInteger)days {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    return [[self fod_currentCalendarForThread] dateByAddingComponents:components toDate:self options:0];
}

- (NSInteger) fod_daysSince:(NSDate*)date {
    NSCalendar *cal = [self fod_currentCalendarForThread];
    NSDateComponents *components = [cal components:NSDayCalendarUnit
                                                fromDate:date
                                                  toDate:self
                                                 options:0];
    return components.day;
}

-(BOOL) fod_isLastDayOfMonth {
    NSCalendar *cal = [self fod_currentCalendarForThread];
    NSDateComponents *componentsMe =
    [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: self];

    NSDateComponents *componentsTomorrow=[cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate:[self fod_dateByAddingDays:1]];
    return componentsMe.month != componentsTomorrow.month;
}

-(NSInteger) fod_monthValue {
    NSCalendar *cal = [self fod_currentCalendarForThread];
    NSDateComponents *components = [cal components:( NSMonthCalendarUnit) fromDate:self];
    return components.month;
}

-(NSInteger) fod_dayOfMonth {
    NSCalendar *cal = [self fod_currentCalendarForThread];
    NSDateComponents *components = [cal components:(NSDayCalendarUnit) fromDate:self];
    return components.day;
}

-(NSInteger) fod_monthOfQuarterValue {
    return (([self fod_monthValue]-1)%4)+1;
}

-(NSInteger) fod_yearValue {
    NSCalendar *cal = [self fod_currentCalendarForThread];
    NSDateComponents *components =
    [cal components:(NSYearCalendarUnit) fromDate: self];
    return components.year;
}

-(NSDate*) fod_nextDay {
    return [self fod_dateByAddingDays:1];
}

@end
