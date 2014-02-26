//
//  FODFormCell.h
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FODFormRow.h"
#import "FODDatePickerViewController.h"
#import "FODPickerViewController.h"

@class FODFormViewController;
@protocol FODSwitchCellDelegate;
@protocol FODTextInputCellDelegate;
@protocol FODImagePickerCellDelegate;

@protocol FODFormCellDelegate<FODDatePickerDelegate, FODPickerViewControllerDelegate, FODSwitchCellDelegate, FODTextInputCellDelegate, FODImagePickerCellDelegate>
- (void)adjustHeight:(CGFloat)newHeight forRowAtIndexPath:(NSIndexPath*)indexPath;
@end


@interface FODFormCell : UITableViewCell

@property (nonatomic,strong) FODFormRow *row;
@property (nonatomic,weak) id<FODFormCellDelegate> delegate;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,weak) FODFormViewController *formViewController;

- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate;

- (void) cellAction:(UINavigationController*)navController;

@end
