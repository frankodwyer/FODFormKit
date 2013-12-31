//
//  FODFormSection.h
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FODFormRow.h"

@interface FODFormSection : NSObject<NSFastEnumeration>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,readonly) NSArray *rows;

- (id)initWithForm:(FODForm*)form;

- (id) objectAtIndexedSubscript:(NSInteger)index;

- (NSUInteger) numberOfRows;

- (void) addRow:(FODFormRow*)row;
- (void) insertRow:(FODFormRow*)row atIndex:(NSUInteger)index;
- (void) removeRowsInArray:(NSArray*)rows;

@end

