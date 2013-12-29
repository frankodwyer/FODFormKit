//
//  FODTextInputCell.h
//  fodUIKit
//
//  Created by Frank on 30/09/2012.
//  Copyright (c) 2012 Desirepath. All rights reserved.
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

@property (weak, nonatomic) id<FODTextInputCellDelegate> delegate;
@property (nonatomic) UIKeyboardType keyboardType;

@end
