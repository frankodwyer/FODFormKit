//
//  FODCellFactory.m
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODCellFactory.h"

#import "FODTextInputRow.h"
#import "FODSelectionRow.h"
#import "FODDateSelectionRow.h"
#import "FODFormRow.h"

#import "FODTextInputCell.h"
#import "FODSubformCell.h"
#import "FODDatePickerCell.h"
#import "FODPickerCell.h"

@interface FODCellFactory()

@property (weak, nonatomic) UITableView *tableView;

@end


@implementation FODCellFactory

- (id) initWithTableView:(UITableView*)tableView
{
    self = [super init];
    if (self) {
        _tableView = tableView;
        [_tableView registerNib:self.nibForSwitchCell forCellReuseIdentifier:self.reuseIdentifierForFODBooleanRow];
        [_tableView registerClass:self.classForSubformCell forCellReuseIdentifier:self.reuseIdentifierForFODFormModel];
        [_tableView registerClass:self.classForDatePickerCell forCellReuseIdentifier:self.reuseIdentifierForFODDateSelectionRow];
        [_tableView registerClass:self.classForPickerCell forCellReuseIdentifier:self.reuseIdentifierForFODSelectionRow];
    }
    return self;
}

- (FODFormCell*) cellForRow:(FODFormRow*)row {
    return ([self.tableView dequeueReusableCellWithIdentifier:[self reuseIdentifierForRow:row]]);
}

- (NSString*)reuseIdentifierForRow:(FODFormRow*)row {
    if ([row isKindOfClass:[FODTextInputRow class]]) {
        if (row.title) {
            NSString *reuseIdentifier = [self reuseIdentifierForTextInputRowWithTitle:row];
            [_tableView registerNib:self.nibForTextInputCellWithTitle forCellReuseIdentifier:reuseIdentifier];
            return reuseIdentifier;
        } else {
            NSString *reuseIdentifier = [self reuseIdentifierForTextInputRowWithoutTitle:row];
            [_tableView registerNib:self.nibForTextInputCellNoTitle forCellReuseIdentifier:reuseIdentifier];
            return reuseIdentifier;
        }
    } else {
        NSString *className = NSStringFromClass([row class]);
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"reuseIdentifierFor%@", className]);
        IMP imp = [self methodForSelector:selector];
        NSString* (*func)(id, SEL) = (void *)imp;
        return func(self,selector);
    }
}

#pragma mark classes / nibs

- (Class) classForSubformCell {
    return [FODSubformCell class];
}

- (Class) classForDatePickerCell {
    return [FODDatePickerCell class];
}

- (Class) classForPickerCell {
    return [FODPickerCell class];
}

- (UINib*) nibForTextInputCellNoTitle {
    return [UINib nibWithNibName:@"FODTextInputCell" bundle:nil];
}

- (UINib*) nibForTextInputCellWithTitle {
    return [UINib nibWithNibName:@"FODTextInputCell2" bundle:nil];
}

- (UINib*) nibForSwitchCell {
    return [UINib nibWithNibName:@"FODSwitchCell" bundle:nil];
}

#pragma  mark reuse identifiers

- (NSString *)reuseIdentifierForFODSelectionRow {
    return @"FODPickerCell";
}

- (NSString *)reuseIdentifierForFODDateSelectionRow {
    return @"FODDatePickerCell";
}

- (NSString*)reuseIdentifierForFODFormModel {
    return @"FODFormCell";
}

- (NSString *)reuseIdentifierForFODBooleanRow {
    return @"FODSwitchCell";
}

- (NSString*)reuseIdentifierForTextInputRowWithoutTitle:(FODFormRow*)row {
    return [NSString stringWithFormat:@"FODTextInputCell2_%@_%@", @(row.indexPath.section), @(row.indexPath.row)];
}

- (NSString*)reuseIdentifierForTextInputRowWithTitle:(FODFormRow*)row {
    return [NSString stringWithFormat:@"FODTextInputCell_%@_%@", @(row.indexPath.section), @(row.indexPath.row)];
}

@end
