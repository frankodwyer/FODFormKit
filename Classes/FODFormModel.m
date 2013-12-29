//
//  FODFormModel.m
//  FormKitDemo
//
//  Created by Frank on 26/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODFormModel.h"

@interface FODFormModel()
@end

@implementation FODFormModel

- (id)init
{
    self = [super init];
    if (self) {
        _sections = [NSMutableArray array];
    }
    return self;
}

- (id)objectForKeyedSubscript:(id)key {
    if (![key isKindOfClass:[NSIndexPath class]]) {
        return [self valueForKeyPath:key];
    } else {
        NSIndexPath *idx = (NSIndexPath*)key;
        FODFormSection *section = self.sections[idx.section];
        return section[idx.row];
    }
}

- (id) objectAtIndexedSubscript:(NSInteger)index {
    return self.sections[index];
}

- (NSUInteger)numberOfSections {
    return self.sections.count;
}

- (id)valueForKey:(NSString *)key {
    // XX: build a dictionary key -> row for fast lookup?
    __block FODFormRow* rowWithKey = nil;

    [self.sections enumerateObjectsUsingBlock:^(FODFormSection *section, NSUInteger idx, BOOL *stop) {
        for (FODFormRow* row in section) {
            if ([row.key isEqualToString:key]) {
                rowWithKey = row;
                *stop = YES;
                break;
            }
        }
    }];

    return rowWithKey;
}

- (id) valueForKeyPath:(NSString *)keyPath {
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];

    __block FODFormModel *model = self;
    __block FODFormRow *rowResult = nil;

    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {

        rowResult = [model valueForKey:key];
        if (idx != keys.count-1) {
            NSAssert([rowResult isKindOfClass:[FODFormModel class]], @"Intermediate key '%@' in '%@' is not a FormModel", key, keyPath);
            model = (FODFormModel*)rowResult;
        }
    }];

    return rowResult.currentValue;
}

@end
