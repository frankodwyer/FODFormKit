//
//  FODInlineDatePickerCell.m
//  FormKitDemo
//
//  Created by frank on 12/31/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODInlineDatePickerCell.h"
#import "FODDatePickerViewController.h"

@interface FODInlineDatePickerCell ()<FODDatePickerDelegate>
@property (strong,nonatomic) NSDate *date;
@end


@implementation FODInlineDatePickerCell

- (void)configureCellForRow:(FODFormRow *)row
               withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];
    self.date = (NSDate*)row.workingValue;
}

- (UIViewController *)createEditorController {
    FODDatePickerViewController *vc = [[FODDatePickerViewController alloc] init];
    vc.delegate = self;
    return vc;
}

- (CGFloat)heightForEditorController:(CGFloat)maxHeight {
    return 390;
}

- (void) setDate:(NSDate *)date {
    _date = date;
    self.row.workingValue = date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    self.valueLabel.text = [df stringFromDate:date];
}

- (void) dateSelected:(NSDate*)date
             userInfo:(id)userInfo {

    self.date = date;
}

@end
