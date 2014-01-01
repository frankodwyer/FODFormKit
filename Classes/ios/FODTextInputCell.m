//
//  FODTextInputCell.m
//
//  Created by Frank on 30/09/2012.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODTextInputCell.h"
#import "FODCellFactory.h"

@implementation FODTextInputCell

- (IBAction)editingDidEnd:(id)sender {
    [self.delegate valueChangedTo:self.textField.text userInfo:self.row];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.delegate startedEditing:self.row];
}

-(void)touchesBegan:(NSSet*)touches
          withEvent:(UIEvent*)event {

    if (!self.textField.isFirstResponder) {
        [self.textField becomeFirstResponder];
    }
}

- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate {
    [super configureCellForRow:row withDelegate:delegate];
    self.delegate = delegate;
    self.textField.inputAccessoryView = [self.delegate textInputAccessoryView];
    self.textField.text = (NSString*)row.workingValue;
    self.textField.textColor = [FODCellFactory editableItemColor];
    self.textField.placeholder = (NSString*)row.placeHolder;
    self.titleLabel.text = row.title;
}

- (BOOL) isEditable {
    return YES;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)cellAction:(UINavigationController*)navController {
    if (!self.textField.isFirstResponder) {
        [self.textField becomeFirstResponder];
    }
}

@end
