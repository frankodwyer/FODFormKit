//
//  FODForm.m
//  FormKitDemo
//
//  Created by Frank on 26/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
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

    // XXX: move this logic into FODFormSection class and add an efficent way to insert multiple rows with renumbering of indexPaths
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

    // XXX: move this logic into FODFormSection class and add an efficent way to remove multiple rows with renumbering of indexPath
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

// serializes the form to a property list format
- (id) toPlist {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.title) {
        result[@"title"] = self.title;
    }
    if (self.key) {
        result[@"key"] = self.key;
    }
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:self.sections.count];
    [self.sections enumerateObjectsUsingBlock:^(FODFormSection* section, NSUInteger idx, BOOL *stop) {
        [sections addObject:section.toPlist];
    }];
    result[@"sections"] = sections;
    return [NSDictionary dictionaryWithDictionary:result];
}

+ (FODForm*) formFromPlist:(id)plist
               withBuilder:(FODFormBuilder*)builder {

    [builder startFormWithTitle:plist[@"title"]
                         andKey:plist[@"key"]];

    NSArray *sections = plist[@"sections"];
    for (id sectionPlist in sections) {
        [FODFormSection fromPlist:sectionPlist
                      withBuilder:builder];
    }

    return [builder finishForm];
}

// constructs a form from an in memory plist
+ (FODForm*) formFromPlist:(id)plist {
    return [self formFromPlist:plist
               withBuilder:[[FODFormBuilder alloc] init]];
}

@end
