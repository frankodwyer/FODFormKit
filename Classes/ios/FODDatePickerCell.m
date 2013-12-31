//
//  FODPicker.m
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODDatePickerCell.h"

#import "FODDatePickerViewController.h"

@interface FODDatePickerCell ()

@end


@implementation FODDatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.textColor = [UIColor blackColor];
    }
    return self;
}

- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    self.detailTextLabel.text = [df stringFromDate:(NSDate*)row.workingValue];
    self.textLabel.text = row.title;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)cellAction:(UINavigationController*)navController {
    FODDatePickerViewController *vc = [[FODDatePickerViewController alloc] init];
    vc.userInfo = self.row;
    vc.delegate = self.delegate;
    vc.title = self.row.title;
    [navController pushViewController:vc animated:YES];
}

@end
