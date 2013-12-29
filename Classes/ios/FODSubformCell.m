//
//  FODSubformCell.m
//  FormKitDemo
//
//  Created by frank on 12/29/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODSubformCell.h"

#import "FODFormViewController.h"

@implementation FODSubformCell

- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    self.textLabel.text = row.title;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)cellAction:(UINavigationController*)navController {
//    FODFormViewController *vc = [[FODFormViewController alloc] initWithStyle:UITableViewStyleGrouped
//                                                                    andModel:(FODFormModel*)self.row
//                                                                    userInfo:self];
    FODFormViewController *vc = [[FODFormViewController alloc] initWithModel:(FODFormModel*)self.row
                                                                    userInfo:self];
    vc.title = self.row.title;
    [navController pushViewController:vc animated:YES];
}

@end
