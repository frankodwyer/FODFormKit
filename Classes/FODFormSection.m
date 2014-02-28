//
//  FODFormSection.m
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODFormSection.h"
#import "FODForm.h"
#import "FODFormBuilder.h"

@interface FODFormSection()
@property (nonatomic,strong) NSMutableArray *mutRows;
@property (nonatomic,weak) FODForm *form;
@property (nonatomic, readonly) NSArray * visibleRows;
@end

@implementation FODFormSection

- (id)initWithForm:(FODForm*)form
{
    self = [super init];
    if (self) {
        _form = form;
        _mutRows = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id) objectAtIndexedSubscript:(NSInteger)index {
    return self.visibleRows[index];
}

- (NSUInteger) numberOfRows {
    return self.visibleRows.count;
}

- (NSArray *)visibleRows
{
    return [self.mutRows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden == NO"]];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [self.visibleRows countByEnumeratingWithState:state objects:buffer count:len];
}

- (void)addRow:(FODFormRow *)row {
    NSAssert(row.indexPath.row == self.mutRows.count, @"Programming error: indexPath for row is %@, expected row index to be %@", row.indexPath, @(self.mutRows.count));
    [self.mutRows addObject:row];
    [self.form row:row wasAddedInSection:self];
}

- (void)removeRow:(FODFormRow *)row {
    [self.mutRows removeObject:row];
    [self.form row:row wasRemovedFromSection:self];
}

- (void) insertRow:(FODFormRow*)row atIndex:(NSUInteger)index {
    [self.mutRows insertObject:row atIndex:index];
    [self.form row:row wasAddedInSection:self];
}

- (void) removeRowsInArray:(NSArray*)rows {
    [self.mutRows removeObjectsInArray:rows];
    [rows enumerateObjectsUsingBlock:^(id row, NSUInteger idx, BOOL *stop) {
        [self.form row:row wasRemovedFromSection:self];
    }];
}

- (NSArray *)rows {
    return [NSArray arrayWithArray:self.mutRows];
}

// serializes to a property list format (array or dictionary)
- (id) toPlist {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.title) {
        result[@"title"] = self.title;
    }
    if (self.dependency) {
        result[@"dependency"] = self.dependency;
    }
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:self.mutRows.count];
    [self.rows enumerateObjectsUsingBlock:^(FODFormRow* row, NSUInteger idx, BOOL *stop) {
        [rows addObject:row.toPlist];
    }];
    result[@"rows"] = rows;
    return [NSDictionary dictionaryWithDictionary:result];
}

// constructs from an in memory plist
+ (FODFormSection*) fromPlist:(id)plist
           withBuilder:(FODFormBuilder*)builder {

    FODFormSection *section = [builder section:plist[@"title"]];

    section.dependency = plist[@"dependency"];

    NSArray *rows = plist[@"rows"];
    for (id rowPlist in rows) {
        [FODFormRow fromPlist:rowPlist
                  withBuilder:builder];
    }

    return section;
}

@end
