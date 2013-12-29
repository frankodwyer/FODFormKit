//  NSDate+Dateutils.h
//
//  Created by frank on 5/25/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSDate (Dateutils)

- (NSCalendar*) fod_currentCalendarForThread;
- (NSDate*) fod_startOfDay;
- (NSDate*) fod_dateByAddingDays:(NSInteger)days;
- (NSDate*) fod_nextDay;
- (NSInteger) fod_monthValue;
- (NSInteger) fod_dayOfMonth;
- (NSInteger) fod_yearValue;
- (NSInteger) fod_monthOfQuarterValue;
- (BOOL) fod_isLastDayOfMonth;
- (NSInteger) fod_daysSince:(NSDate*)date;

@end
