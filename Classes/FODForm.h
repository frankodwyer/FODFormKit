//
//  FODForm.h
//  FormKitDemo
//
//  Created by Frank on 26/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//  
//  Modified work Copyright 2014 Thimo Bess, arconsis IT-Solutions GmbH
//  Modified work Copyright 2014 Jonas Stubenrauch, arconsis IT-Solutions GmbH
//

#import <Foundation/Foundation.h>

#import "FODFormRow.h"
#import "FODFormSection.h"
#import "FODFormRow.h"
#import "FODFormSelectableRow.h"


@interface FODForm : FODFormSelectableRow

@property (nonatomic, weak) FODForm *parentForm;
@property (nonatomic, copy) NSMutableArray *sections;
@property (nonatomic, readonly) NSArray *visibleSections;

- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (id)objectAtIndexedSubscript: (NSInteger) index;

- (FODFormRow*)rowForKey:(NSString *)key;

- (NSUInteger) numberOfSections;

- (void) undoEdits;
- (void) commitEdits;

// returns array of the affected index paths
- (NSArray*) insertRowsFromSubform:(FODForm*)form;
- (NSArray*) removeRowsFromSubform:(FODForm*)form;

- (void) row:(FODFormRow*)row wasAddedInSection:(FODFormSection*)section;
- (void) row:(FODFormRow*)row wasRemovedFromSection:(FODFormSection*)section;


// serializes to a property list format (array or dictionary)
- (id) toPlist;

// constructs from an in memory plist
+ (FODForm*) fromPlist:(id)plist;

@end
