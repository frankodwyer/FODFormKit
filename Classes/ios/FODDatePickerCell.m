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

@property (nonatomic, weak) id<FODDatePickerDelegate> delegate;

@end


@implementation FODDatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}

- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    self.detailTextLabel.text = [df stringFromDate:(NSDate*)row.currentValue];
    self.textLabel.text = row.title;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.delegate = delegate;
}

- (void)cellAction:(UINavigationController*)navController {
    FODDatePickerViewController *vc = [[FODDatePickerViewController alloc] init];
    vc.userInfo = self.row;
    vc.delegate = self.delegate;
    [navController pushViewController:vc animated:YES];
}

@end
