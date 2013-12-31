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
#import "FODForm.h"

#import "FODTextInputCell.h"
#import "FODSubformCell.h"
#import "FODDatePickerCell.h"
#import "FODPickerCell.h"
#import "FODExpandingSubformCell.h"

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
        [_tableView registerNib:self.nibForExpandingSubformCell forCellReuseIdentifier:self.reuseIdentifierForFODExpandingSubform];
        [_tableView registerNib:self.nibForInlineDatePickerCell forCellReuseIdentifier:self.reuseIdentifierForFODInlineDatePicker];
        [_tableView registerClass:self.classForSubformCell forCellReuseIdentifier:self.reuseIdentifierForFODForm];
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
    } else if ([row isKindOfClass:[FODForm class]]) {
        FODForm *form = (FODForm*)row;
        if (form.expands) {
            return self.reuseIdentifierForFODExpandingSubform;
        } else {
            return self.reuseIdentifierForFODForm;
        }
    } else if ([row isKindOfClass:[FODDateSelectionRow class]]) {
        if (row.displayInline) {
            return self.reuseIdentifierForFODInlineDatePicker;
        } else {
            return self.reuseIdentifierForFODDateSelectionRow;
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

- (UINib*) nibForExpandingSubformCell {
    return [UINib nibWithNibName:@"FODExpandingSubformCell" bundle:nil];
}

- (UINib*) nibForInlineDatePickerCell {
    return [UINib nibWithNibName:@"FODInlineDatePickerCell" bundle:nil];
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

- (NSString*)reuseIdentifierForFODForm {
    return @"FODFormCell";
}

- (NSString*)reuseIdentifierForFODExpandingSubform {
    return @"FODExpandingSubformCell";
}

- (NSString*)reuseIdentifierForFODInlineDatePicker {
    return @"FODInlineDatePickerCell";
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
