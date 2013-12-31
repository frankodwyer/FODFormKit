//
//  FODInlineDatePickerCell.m
//  FormKitDemo
//
//  Created by frank on 12/31/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODInlineDatePickerCell.h"
#import "FODDatePickerViewController.h"
#import "FODFormViewController.h"

@interface FODInlineDatePickerCell ()<FODDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong,nonatomic) FODDatePickerViewController *datePicker;
@property (strong,nonatomic) NSDate *date;
@end


@implementation FODInlineDatePickerCell

- (void)configureCellForRow:(FODFormRow *)row
               withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];
    self.date = (NSDate*)row.workingValue;
    self.expanded = row.expanded;
    if (self.expanded) {
        self.datePicker = [[FODDatePickerViewController alloc] init];
        self.datePicker.usedInline = YES;
        self.datePicker.startValue = (NSDate*)self.row.workingValue;
        self.datePicker.view.frame = CGRectMake(0,44, self.bounds.size.width,390+44);
        [self.contentView addSubview:self.datePicker.view];
        [self.formViewController addChildViewController:self.datePicker];
        [self.datePicker didMoveToParentViewController:self.formViewController];
        self.datePicker.delegate = self;
    } else {
        self.datePicker = nil;
    }
}

- (void) setExpanded:(BOOL)expanded {
    [super setExpanded:expanded];
    if (self.expanded) {
        [self.delegate adjustHeight:390+44
                  forRowAtIndexPath:self.row.indexPath];
    } else {
        [self.delegate adjustHeight:44
                  forRowAtIndexPath:self.row.indexPath];
    }
}

- (void) setDate:(NSDate *)date {
    _date = date;
    self.row.workingValue = date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    self.valueLabel.text = [df stringFromDate:date];
}

- (void) removeDatePicker:(FODDatePickerViewController*)vc {
    if (vc) {
        [vc.view removeFromSuperview];
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}

// we need to hold the date picker state in the row model in case of cell reuse/allocation
- (void) setDatePicker:(FODDatePickerViewController *)datePicker {
    FODDatePickerViewController *previousValue = self.datePicker;

    if (datePicker) {
        self.row.viewState[@"datePicker"] = datePicker;
    } else {
        [self.row.viewState removeObjectForKey:@"datePicker"];
    }

    if (previousValue) {
        [self removeDatePicker:previousValue];
    }
}

- (FODDatePickerViewController *)datePicker {
    return self.row.viewState[@"datePicker"];
}

- (void) dateSelected:(NSDate*)date
             userInfo:(id)userInfo {

    self.date = date;
}

@end
