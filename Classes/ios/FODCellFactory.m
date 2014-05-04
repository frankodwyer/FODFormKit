//
//  FODCellFactory.m
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//  
//  Modified work Copyright 2014 Thimo Bess, arconsis IT-Solutions GmbH
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
@property (weak, nonatomic) FODFormViewController *formViewController;
@end


@implementation FODCellFactory

- (id) initWithTableView:(UITableView*)tableView andFormViewController:(FODFormViewController *)formViewController
{
    self = [super init];
    if (self) {
        _tableView = tableView;
        _formViewController = formViewController;
        [self registerReuseIdentifiersForTableView:_tableView];
    }
    return self;
}

- (void) registerReuseIdentifiersForTableView:(UITableView*)tableView {
    [tableView registerNib:self.nibForMultiLineTextInputRow forCellReuseIdentifier:self.reuseIdentifierForFODMultiLineTextInputRow];
    [tableView registerNib:self.nibForImagePickerRow forCellReuseIdentifier:self.reuseIdentifierForFODImagePickerRow];
    [tableView registerNib:self.nibForSwitchCell forCellReuseIdentifier:self.reuseIdentifierForFODBooleanRow];
    [tableView registerNib:self.nibForExpandingSubformCell forCellReuseIdentifier:self.reuseIdentifierForFODExpandingSubform];
    [tableView registerNib:self.nibForInlineDatePickerCell forCellReuseIdentifier:self.reuseIdentifierForFODInlineDatePicker];
    [tableView registerNib:self.nibForInlinePickerCell forCellReuseIdentifier:self.reuseIdentifierForFODInlinePicker];
    [tableView registerClass:self.classForSubformCell forCellReuseIdentifier:self.reuseIdentifierForFODForm];
    [tableView registerClass:self.classForDatePickerCell forCellReuseIdentifier:self.reuseIdentifierForFODDateSelectionRow];
    [tableView registerClass:self.classForPickerCell forCellReuseIdentifier:self.reuseIdentifierForFODSelectionRow];
}

+ (UIColor*) editableItemColor {
    return [UIColor blueColor];
}

- (FODFormCell*) cellForRow:(FODFormRow*)row {
    FODFormCell *result = ([self.tableView dequeueReusableCellWithIdentifier:[self reuseIdentifierForRow:row]]);
    result.tableView = self.tableView;
    result.formViewController = self.formViewController;
    return result;
}

- (NSString*)reuseIdentifierForRow:(FODFormRow*)row {
    if ([row isKindOfClass:[FODTextInputRow class]]) {
        if (row.title.length > 0) {
            NSString *reuseIdentifier = [self reuseIdentifierForTextInputRowWithTitle:row];
            [_tableView registerNib:self.nibForTextInputCellWithTitle forCellReuseIdentifier:reuseIdentifier];
            return reuseIdentifier;
        } else {
            NSString *reuseIdentifier = [self reuseIdentifierForTextInputRowWithoutTitle:row];
            [_tableView registerNib:self.nibForTextInputCellNoTitle forCellReuseIdentifier:reuseIdentifier];
            return reuseIdentifier;
        }
    }
    else if ([row isKindOfClass:[FODForm class]]) {
        FODForm *form = (FODForm*)row;
        if (form.displayInline) {
            return self.reuseIdentifierForFODExpandingSubform;
        } else {
            return self.reuseIdentifierForFODForm;
        }
    }
    else if ([row isKindOfClass:[FODDateSelectionRow class]]) {
        if (row.displayInline) {
            return self.reuseIdentifierForFODInlineDatePicker;
        } else {
            return self.reuseIdentifierForFODDateSelectionRow;
        }
    }
    else if ([row isKindOfClass:[FODSelectionRow class]]) {
        if (row.displayInline) {
            return self.reuseIdentifierForFODInlinePicker;
        } else {
            return self.reuseIdentifierForFODSelectionRow;
        }
    }
    else {
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

- (UINib*) nibForInlinePickerCell {
    return [UINib nibWithNibName:@"FODInlinePickerCell" bundle:nil];
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

- (UINib*) nibForImagePickerRow {
    return [UINib nibWithNibName:@"FODImagePickerCell" bundle:nil];
}

- (UINib*) nibForMultiLineTextInputRow {
    return [UINib nibWithNibName:@"FODMultiLineTextInputCell" bundle:nil];
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

- (NSString*)reuseIdentifierForFODInlinePicker {
    return @"FODInlinePickerCell";
}

- (NSString *)reuseIdentifierForFODBooleanRow {
    return @"FODSwitchCell";
}

- (NSString *)reuseIdentifierForFODImagePickerRow {
    return @"FODImagePickerCell";
}


- (NSString *)reuseIdentifierForFODMultiLineTextInputRow {
    return @"FODMultiLineTextInputCell";
}

- (NSString*)reuseIdentifierForTextInputRowWithoutTitle:(FODFormRow*)row {
    return [NSString stringWithFormat:@"FODTextInputCell_%@_%@", @(row.indexPath.section), @(row.indexPath.row)];
}

- (NSString*)reuseIdentifierForTextInputRowWithTitle:(FODFormRow*)row {
    return [NSString stringWithFormat:@"FODTextInputCell2_%@_%@", @(row.indexPath.section), @(row.indexPath.row)];
}

@end
