//
//  FODFormModel.h
//  FormKitDemo
//
//  Created by Frank on 26/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FODFormRow.h"
#import "FODFormSection.h"
#import "FODFormRow.h"

@interface FODFormModel : FODFormRow

@property (nonatomic, weak) FODFormModel *parentForm;
@property (nonatomic, copy) NSMutableArray *sections;

- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (id) objectAtIndexedSubscript: (NSInteger) index;

- (NSUInteger) numberOfSections;

- (void) undoEdits;
- (void) commitEdits;

@end
