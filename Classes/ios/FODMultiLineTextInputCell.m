//
//  FODTextInputCell.m
//
//  Created by Frank on 30/09/2012.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODTextInputCell.h"
#import "FODMultiLineTextInputCell.h"
#import "FODCellFactory.h"
#import "FODFormViewController.h"


@implementation FODMultiLineTextInputCell

- (IBAction)editingDidEnd:(id)sender {
    [self.delegate valueChangedTo:self.textView.text userInfo:self.row];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    if (!self.textView.isFirstResponder) {
        [self.textView becomeFirstResponder];
    }
}


- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate {
    [super configureCellForRow:row withDelegate:delegate];

    self.delegate = delegate;

    self.textView.delegate = self;
    self.textView.inputAccessoryView = [self.delegate textInputAccessoryView];
    self.textView.text = (NSString *)row.workingValue;
    self.textView.textColor = [FODCellFactory editableItemColor];

    self.titleLabel.text = row.title;
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)cellAction:(UINavigationController*)navController {
    if (!self.textView.isFirstResponder) {
        [self.textView becomeFirstResponder];
    }
}


#pragma mark - UITextViewDelegate -
- (void)textViewDidChange:(UITextView *)textView
{
    //if (![self.row.workingValue isEqual:textView.text]) {
    if (![textView.text isEqual:self.row.workingValue]) {
        self.row.workingValue = textView.text;

    }
    if (textView.contentSize.height != self.bounds.size.height) {
        [self.delegate adjustHeight:(textView.contentSize.height + textView.frame.origin.y + 8) forRowAtIndexPath:self.row.indexPath];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self editingDidEnd:self.textView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.delegate startedEditing:self.row];
}

@end
