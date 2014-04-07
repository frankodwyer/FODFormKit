//
//  FODForm.m
//  FormKitDemo
//
//  Created by Frank on 26/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//  
//  Modified work Copyright 2014 Thimo Bess, arconsis IT-Solutions GmbH
//  Modified work Copyright 2014 Jonas Stubenrauch, arconsis IT-Solutions GmbH
//

#import "FODForm.h"
#import "FODFormBuilder.h"

@interface FODForm()

@property (nonatomic,strong) NSMutableDictionary *keysToRows;


@end

@implementation
FODForm

- (id)init
{
    self = [super init];
    if (self) {
        _keysToRows = [NSMutableDictionary dictionary];
        _sections = [NSMutableArray array];
    }
    return self;
}

- (id)objectForKeyedSubscript:(id)key {
    if (![key isKindOfClass:[NSIndexPath class]]) {
        return [self valueForKeyPath:key];
    } else {
        NSIndexPath *idx = (NSIndexPath*)key;
        FODFormSection *section = self.visibleSections[idx.section];
        return section[idx.row];
    }
}

- (id) objectAtIndexedSubscript:(NSInteger)index {
    return self.visibleSections[index];
}

- (NSUInteger)numberOfSections {

    return self.visibleSections.count;
}

- (NSArray *)visibleSections
{
    return  [self.sections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden == NO"]];
}

- (void) row:(FODFormRow*)row wasAddedInSection:(FODFormSection*)section {
    NSAssert(!self.keysToRows[row.key], @"Cannot add key '%@' a second time, as it is already in use by this form ('%@')", row.key, self.title);
    self.keysToRows[row.key] = row;
}

- (void) row:(FODFormRow*)row wasRemovedFromSection:(FODFormSection*)section {
    [self.keysToRows removeObjectForKey:row.key];
}

- (FODFormRow*)rowForKey:(NSString *)key {
    return self.keysToRows[key];
}

- (id) valueForKey:(NSString *)key {
    return [self rowForKey:key].workingValue;
}

- (FODFormRow*) rowForKeyPath:(NSString *)keyPath {
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];

    __block FODForm *form = self;
    __block FODFormRow *rowResult = nil;

    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {

        rowResult = [form rowForKey:key];
        if (idx != keys.count-1) {
            NSAssert([rowResult isKindOfClass:[FODForm class]], @"Intermediate key '%@' in '%@' is not a FODForm", key, keyPath);
            form = (FODForm*)rowResult;
        }
    }];

    return rowResult;
}

- (id) valueForKeyPath:(NSString *)keyPath {
    return [self rowForKeyPath:keyPath].workingValue;
}

- (void) undoEdits {
    [self.sections enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(FODFormSection *section, NSUInteger idx, BOOL *stop) {
        [section.rows enumerateObjectsUsingBlock:^(FODFormRow *row, NSUInteger idx, BOOL *stop) {
            row.workingValue = row.initialValue;
            row.expanded = NO;
            row.viewState = nil;
        }];
    }];
}

- (void) commitEdits {
    [self.sections enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(FODFormSection *section, NSUInteger idx, BOOL *stop) {
        [section.rows enumerateObjectsUsingBlock:^(FODFormRow *row, NSUInteger idx, BOOL *stop) {
            row.initialValue = row.workingValue;
            row.expanded = NO;
            row.viewState = nil;
        }];
    }];
}

- (NSArray*) insertRowsFromSubform:(FODForm*)form {

    NSIndexPath *insertionPoint = [NSIndexPath indexPathForRow:form.indexPath.row+1 inSection:form.indexPath.section];
    NSMutableArray *indexPaths = [NSMutableArray array];

    FODFormSection *affectedSection = self.sections[insertionPoint.section];

    // XXX: move this logic into FODFormSection class and add an efficent way to insert multiple rows with renumbering of indexPaths
    for (FODFormSection *section in form.sections) {
        for (FODFormRow *row in section.rows) {
            [indexPaths addObject:insertionPoint];
            FODFormRow *newRow = row;
            newRow.indexPath = insertionPoint;
            [affectedSection insertRow:newRow atIndex:insertionPoint.row];
            insertionPoint = [NSIndexPath indexPathForRow:insertionPoint.row+1 inSection:insertionPoint.section];
        }
    }

    // renumber index paths below the inserted rows
    while (insertionPoint.row < affectedSection.rows.count) {
        FODFormRow *row = affectedSection.rows[insertionPoint.row];
        row.indexPath = insertionPoint;
        insertionPoint = [NSIndexPath indexPathForRow:insertionPoint.row+1 inSection:insertionPoint.section];
    }

    return indexPaths;
}

- (NSArray*) removeRowsFromSubform:(FODForm*)form {

    NSIndexPath *deletionPoint = [NSIndexPath indexPathForRow:form.indexPath.row+1 inSection:form.indexPath.section];
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSMutableArray *rowsToRemove = [NSMutableArray array];

    FODFormSection *affectedSection = self.sections[deletionPoint.section];

    // XXX: move this logic into FODFormSection class and add an efficent way to remove multiple rows with renumbering of indexPath
    for (FODFormSection *section in form.sections) {
        for (FODFormRow *row in section.rows) {
            [indexPaths addObject:deletionPoint];
            [rowsToRemove addObject:row];
            deletionPoint = [NSIndexPath indexPathForRow:deletionPoint.row+1 inSection:deletionPoint.section];
        }
    }

    // renumber index paths below the deleted rows
    while (deletionPoint.row < affectedSection.rows.count) {
        FODFormRow *row = affectedSection.rows[deletionPoint.row];
        row.indexPath = [NSIndexPath indexPathForRow:row.indexPath.row - indexPaths.count inSection:row.indexPath.section];
        deletionPoint = [NSIndexPath indexPathForRow:deletionPoint.row+1 inSection:deletionPoint.section];
    }

    [affectedSection removeRowsInArray:rowsToRemove];

    return indexPaths;
}

// serializes the form to a property list format
- (id) toPlist {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result addEntriesFromDictionary:[super toPlist]];

    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:self.sections.count];
    [self.sections enumerateObjectsUsingBlock:^(FODFormSection* section, NSUInteger idx, BOOL *stop) {
        [sections addObject:section.toPlist];
    }];
    result[@"sections"] = sections;

    return [NSDictionary dictionaryWithDictionary:result];
}

+ (FODFormRow*) fromPlist:(id)plist
              withBuilder:(FODFormBuilder*)builder {

    [builder startFormWithTitle:plist[@"title"]
                         andKey:plist[@"key"]].displayInline = [plist[@"displayInline"] boolValue];

    NSArray *sections = plist[@"sections"];
    for (id sectionPlist in sections) {
        [FODFormSection fromPlist:sectionPlist
                      withBuilder:builder];
    }

    return [builder finishForm];
}

// constructs a form from an in memory plist
+ (FODForm*) fromPlist:(id)plist {
    return (FODForm*)[self fromPlist:plist
                         withBuilder:[[FODFormBuilder alloc] init]];
}

- (NSDictionary *)extractValues
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];

    for (FODFormSection *section in self.sections) {
        NSArray *rows = section.rows;
        for (FODFormRow *row in rows) {
            [dictionary addEntriesFromDictionary:[row extractValues]];
        }
    }

    return dictionary;
}

- (void)applyValue:(id)value
{
    for (FODFormSection *section in self.sections) {
        NSArray *rows = section.rows;
        for (FODFormRow *row in rows) {
            id rowValue = value[row.key];

            if (rowValue) {
                [row applyValue:rowValue];
            }
        }
    }
}

@end
