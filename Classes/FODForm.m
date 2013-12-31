//
//  FODForm.m
//  FormKitDemo
//
//  Created by Frank on 26/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODForm.h"

@interface FODForm()

@property (nonatomic,strong) NSMutableDictionary *keysToRows;

@end

@implementation FODForm

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

    for (FODFormSection *section in form.sections) {
        for (FODFormRow *row in section.rows) {
            [indexPaths addObject:insertionPoint];
            FODFormRow *newRow = [row copy];
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

    for (FODFormSection *section in form.sections) {
        for (FODFormRow *row in section.rows) {
            [indexPaths addObject:deletionPoint];
            [rowsToRemove addObject:self[deletionPoint]];
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

@end
