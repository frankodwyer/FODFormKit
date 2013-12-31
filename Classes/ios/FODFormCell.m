//
//  FODFormCell.m
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODFormCell.h"

@interface FODFormCell ()

@end

@implementation FODFormCell

- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate {

    self.detailTextLabel.text = nil;
    self.textLabel.text = nil;
    self.row = row;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.delegate = delegate;
}

- (void)cellAction:(UINavigationController*)navController {
}

@end
