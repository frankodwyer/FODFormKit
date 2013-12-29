//
//  FODFormCell.h
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FODFormRow.h"

@interface FODFormCell : UITableViewCell

@property (nonatomic,strong) FODFormRow *row;
@property (nonatomic,readonly) BOOL isEditable;

- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate;

- (void) cellAction:(UINavigationController*)navController;

@end
