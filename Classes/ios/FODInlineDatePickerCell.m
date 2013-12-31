//
//  FODInlineDatePickerCell.m
//  FormKitDemo
//
//  Created by frank on 12/31/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODInlineDatePickerCell.h"
#import "FODDatePickerViewController.h"

@interface FODInlineDatePickerCell ()
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong,nonatomic) UIDatePicker *datePicker;
@end


@implementation FODInlineDatePickerCell

- (void)configureCellForRow:(FODFormRow *)row
               withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    self.valueLabel.text = [df stringFromDate:(NSDate*)row.workingValue];
    self.expanded = row.expanded;
}

- (void) setExpanded:(BOOL)expanded {
    if (self.expanded == expanded) {
        return;
    }
    [super setExpanded:expanded];
    if (self.expanded) {
        self.datePicker = [[UIDatePicker alloc] init];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        self.datePicker.frame = CGRectMake(0, 44, self.bounds.size.width, 200);
        [self.contentView addSubview:self.datePicker];
        [self.delegate adjustHeight:200
                  forRowAtIndexPath:self.row.indexPath];
    } else {
        [self.datePicker removeFromSuperview];
        self.datePicker = nil;
        [self.delegate adjustHeight:44
                  forRowAtIndexPath:self.row.indexPath];
    }
}

@end
