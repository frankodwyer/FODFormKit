//
//  FODTextInputCell.h
//
//  Created by Frank on 30/09/2012.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FODFormCell.h"

@protocol FODTextInputCellDelegate

- (void) valueChangedTo:(NSString*)newValue
               userInfo:(id)userInfo;

- (void) startedEditing:(id)userInfo;

- (UIView*) textInputAccessoryView;

@end

@interface FODTextInputCell : FODFormCell <UITextFieldDelegate>

- (IBAction)editingDidEnd:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic) UIKeyboardType keyboardType;

@end
