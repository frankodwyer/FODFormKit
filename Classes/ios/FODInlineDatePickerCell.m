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
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong,nonatomic) FODDatePickerViewController    *datePicker;
@property (strong,nonatomic) NSDate *date;
@end


@implementation FODInlineDatePickerCell

- (void)configureCellForRow:(FODFormRow *)row
               withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];
    self.date = (NSDate*)row.workingValue;
    self.expanded = row.expanded;
}

- (void) setDate:(NSDate *)date {
    _date = date;
    self.row.workingValue = date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    self.valueLabel.text = [df stringFromDate:date];
}

- (void) setExpanded:(BOOL)expanded {
    if (self.expanded == expanded) {
        return;
    }
    [super setExpanded:expanded];
    if (self.expanded) {
        self.datePicker = [[FODDatePickerViewController alloc] init];
        self.datePicker.usedInline = YES;
        self.datePicker.startValue = (NSDate*)self.row.workingValue;
        self.datePicker.view.frame = CGRectMake(0,44, self.bounds.size.width,380+44);
        [self.contentView addSubview:self.datePicker.view];
        [self.delegate adjustHeight:380+44
                  forRowAtIndexPath:self.row.indexPath];
        self.datePicker.delegate = self;
    } else {
        [self.datePicker.view removeFromSuperview];
        self.datePicker = nil;
        [self.delegate adjustHeight:44
                  forRowAtIndexPath:self.row.indexPath];
    }
}

- (void) dateSelected:(NSDate*)date
             userInfo:(id)userInfo {

    self.date = date;
}

@end
