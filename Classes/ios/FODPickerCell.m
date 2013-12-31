//
//  FODPickerCell.m
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODPickerCell.h"
#import "FODPickerViewController.h"

@interface FODPickerCell ()

@end


@implementation FODPickerCell

- (void)configureCellForRow:(FODFormRow *)row
               withDelegate:(id)delegate {
    [super configureCellForRow:row withDelegate:delegate];

    self.delegate = delegate;
}

- (void)cellAction:(UINavigationController*)navController {
    FODPickerViewController *vc = [[FODPickerViewController alloc] init];
    vc.userInfo = self.row;
    vc.delegate = self.delegate;
    [navController pushViewController:vc animated:YES];
}

@end
