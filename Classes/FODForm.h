//
//  FODForm.h
//  FormKitDemo
//
//  Created by Frank on 26/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FODFormRow.h"
#import "FODFormSection.h"
#import "FODFormRow.h"

@interface FODForm : FODFormRow

@property (nonatomic, weak) FODForm *parentForm;
@property (nonatomic, copy) NSMutableArray *sections;

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
+ (FODForm*) formFromPlist:(id)plist;

@end
