//
//  FODPickerCell.m
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODPickerCell.h"
#import "FODPickerViewController.h"
#import "FODSelectionRow.h"

@interface FODPickerCell ()

@end


@implementation FODPickerCell

- (void)configureCellForRow:(FODFormRow *)row
               withDelegate:(id)delegate {
    
    [super configureCellForRow:row withDelegate:delegate];

    self.textLabel.text = row.title;
    self.detailTextLabel.text = (NSString*)row.workingValue;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.delegate = delegate;
}

- (void)cellAction:(UINavigationController*)navController {
    FODPickerViewController *vc = [[FODPickerViewController alloc] init];
    vc.userInfo = self.row;
    vc.delegate = self.delegate;
    vc.items = ((FODSelectionRow*)self.row).items;
    vc.title = self.row.title;
    if (self.row.workingValue) {
        vc.initialSelection = @[self.row.workingValue];
    }
    [navController pushViewController:vc animated:YES];
}

@end
