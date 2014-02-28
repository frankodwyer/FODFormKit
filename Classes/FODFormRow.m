//
//  FODFormRow.m
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODFormRow.h"
#import "FODFormBuilder.h"

@implementation FODFormRow

- (id) copyWithZone:(NSZone *)zone {
    FODFormRow *copy = [[[self class] allocWithZone:zone] init];
    copy.title = [self.title copyWithZone:zone];
    copy.indexPath = [self.indexPath copyWithZone:zone];
    copy.key = [self.key copyWithZone:zone];
    copy.initialValue = [self.initialValue copyWithZone:zone];
    copy.workingValue = [self.workingValue copyWithZone:zone];
    copy.placeHolder = [self.placeHolder copyWithZone:zone];
    copy.expanded = self.expanded;
    copy.displayInline = self.displayInline;
    if (self.viewState.count) { // only make a copy if there are entries - lazy load otherwise
        copy.viewState = [self.viewState copy];
    }
    return copy;
}

- (NSMutableDictionary *)viewState {
    if (!_viewState) {
        _viewState = [[NSMutableDictionary alloc] init];
    }
    return _viewState;
}

- (void) configureWithPlist:(id)plist {
    // subclasses can restore additional properties using this
}

// serializes to a property list format (array or dictionary)
- (id) toPlist {
    return @{
             @"class":NSStringFromClass([self class]),
             @"title":self.title ?: @"",
             @"key":self.key ?: @"",
             @"initialValue":self.initialValue ?: @"",
             @"placeHolder":self.placeHolder ?: @"",
             @"displayInline":@(self.displayInline)};
}

- (NSDictionary *)extractValues
{
    NSDictionary *dictionary;

    if (self.key.length > 0) {
        id value = self.workingValue ? self.workingValue : @"";
        dictionary = @{self.key : value};
    }

    return dictionary;
}

- (void)applyValue:(id)value
{
    self.workingValue = value;
    self.initialValue = value;
}

// constructs from an in memory plist
+ (FODFormRow*) fromPlist:(id)plist
              withBuilder:(FODFormBuilder*)builder {

    NSString *className = plist[@"class"];

    if ([className isEqualToString:@"FODForm"]) {
        return [FODForm fromPlist:plist withBuilder:builder];
    } else {
        FODFormRow* row = [builder rowWithKey:plist[@"key"]
                                      ofClass:NSClassFromString(className)
                                     andTitle:plist[@"title"]
                                     andValue:plist[@"initialValue"]
                               andPlaceHolder:plist[@"placeHolder"]];
        row.displayInline = [plist[@"displayInline"] boolValue];

        [row configureWithPlist:plist];

        return row;
    }

}


@end
