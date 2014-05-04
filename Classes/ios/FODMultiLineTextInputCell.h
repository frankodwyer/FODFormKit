//
//  FODTextInputCell.h
//
//  Modified work Copyright 2014 Jonas Stubenrauch, arconsis IT-Solutions GmbH
//

#import <UIKit/UIKit.h>

#import "FODFormCell.h"


@interface FODMultiLineTextInputCell : FODFormCell <UITextFieldDelegate, UITextViewDelegate>

- (IBAction)editingDidEnd:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic) UIKeyboardType keyboardType;

@end
