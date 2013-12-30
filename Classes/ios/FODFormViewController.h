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
#import "FODForm.h"
#import "FODCellFactory.h"

@class FODFormViewController;

@protocol FODFormViewControllerDelegate <NSObject>

- (void) formSaved:(FODForm*)model
          userInfo:(id)userInfo;

- (void) formCancelled:(FODForm*)model
              userInfo:(id)userInfo;

@optional
- (void) pickerValueChanged:(NSString*)key
                      value:(NSString*)value
                        row:(FODFormRow*)row
                     inForm:(FODFormViewController*)form;

- (NSString*) validateForm:(FODForm*)model
                    inForm:(FODFormViewController*)form;

@end

@interface FODFormViewController : UIViewController <FODTextInputCellDelegate, FODSwitchCellDelegate, FODPickerViewControllerDelegate, UIAlertViewDelegate, FODDatePickerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) FODForm *model;
@property (nonatomic, weak) id<FODFormViewControllerDelegate> delegate;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) FODCellFactory *cellFactory;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithForm:(FODForm*)model
           userInfo:(id)userInfo;

@end
