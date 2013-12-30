//
//  FODFormRow.m
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODFormRow.h"

@implementation FODFormRow

- (id) copyWithZone:(NSZone *)zone {
    FODFormRow *copy = [[[self class] allocWithZone:zone] init];
    copy.title = [self.title copyWithZone:zone];
    copy.indexPath = [self.indexPath copyWithZone:zone];
    copy.key = [self.key copyWithZone:zone];
    copy.initialValue = [self.initialValue copyWithZone:zone];
    copy.workingValue = [self.workingValue copyWithZone:zone];
    copy.placeHolder = [self.placeHolder copyWithZone:zone];
    return copy;
}

@end
