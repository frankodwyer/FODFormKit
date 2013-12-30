//
//  FODSubformCell.m
//  FormKitDemo
//
//  Created by frank on 12/29/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODSubformCell.h"

#import "FODFormViewController.h"

@interface FODSubformCell()<FODFormViewControllerDelegate>

@property (nonatomic,weak) UINavigationController *navigationController;

@end


@implementation FODSubformCell

- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    self.textLabel.text = row.title;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)cellAction:(UINavigationController*)navController {
    FODFormViewController *vc = [[FODFormViewController alloc] initWithModel:(FODForm*)self.row
                                                                    userInfo:self];
    vc.title = self.row.title;
    vc.delegate = self;
    [navController pushViewController:vc animated:YES];
    self.navigationController = navController;
}

- (void)formSaved:(FODForm *)model
         userInfo:(id)userInfo {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)formCancelled:(FODForm *)model
             userInfo:(id)userInfo {
    // no need to pop - we get here if the user pressed back.
}

@end
