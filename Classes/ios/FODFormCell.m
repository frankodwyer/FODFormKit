//
//  FODFormCell.m
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//  
//  Modified work Copyright 2014 Jonas Stubenrauch, arconsis IT-Solutions GmbH
//

#import "FODFormCell.h"
#import "FODCellFactory.h"

@interface FODFormCell ()
@end


@implementation FODFormCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.textColor = [FODCellFactory editableItemColor];
    }
    return self;
}

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
