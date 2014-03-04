//
//  FODTextInputCell.h
//
//  Created by Frank on 30/09/2012.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FODFormCell.h"


@interface FODMultiLineTextInputCell : FODFormCell <UITextFieldDelegate, UITextViewDelegate>

- (IBAction)editingDidEnd:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic) UIKeyboardType keyboardType;

@end
