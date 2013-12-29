//
//  FODDynamicTableViewController.h
//  fodUIKit
//
//  Created by Frank on 29/09/2012.
//  Copyright (c) 2012 Desirepath. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FODTextInputCell.h"
#import "FODSwitchCell.h"
#import "FODPickerViewController.h"
#import "FODDatePickerViewController.h"
#import "FODFormModel.h"
#import "FODCellFactory.h"

@class FODFormViewController;

@protocol FODFormViewControllerDelegate <NSObject>

@optional
- (void) modelSaved:(FODFormModel*)model
             inForm:(FODFormViewController*)form
           userInfo:(id)userInfo;

- (void) pickerValueChanged:(NSString*)key
                      value:(NSString*)value
                        row:(FODFormRow*)row
                     inForm:(FODFormViewController*)form;

- (NSString*) validateForm:(FODFormModel*)model
                    inForm:(FODFormViewController*)form;

@end

@interface FODFormViewController : UIViewController <FODTextInputCellDelegate, FODSwitchCellDelegate, FODPickerViewControllerDelegate, UIAlertViewDelegate, FODDatePickerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) FODFormModel *model;
@property (nonatomic, weak) id<FODFormViewControllerDelegate> delegate;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) FODCellFactory *cellFactory;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithModel:(FODFormModel*)model
           userInfo:(id)userInfo;

//- (id)initWithStyle:(UITableViewStyle)style
//           andModel:(FODFormModel*)model
//           userInfo:(id)userInfo;

@end
