//
//  FODCellFactory.h
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FODFormRow.h"
#import "FODFormCell.h"

@interface FODCellFactory : NSObject

- (id) initWithTableView:(UITableView*)tableView
 andParentViewController:(UIViewController*)parentViewController;

- (FODFormCell*) cellForRow:(FODFormRow*)row;

@end
