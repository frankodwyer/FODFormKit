//
//  FODFormSection.m
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODFormSection.h"

@interface FODFormSection()
@end

@implementation FODFormSection

- (id)init
{
    self = [super init];
    if (self) {
        _rows = [NSMutableArray array];
    }
    return self;
}

- (id) objectAtIndexedSubscript:(NSInteger)index {
    return self.rows[index];
}

- (NSUInteger) numberOfRows {
    return self.rows.count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [self.rows countByEnumeratingWithState:state objects:buffer count:len];
}

@end
