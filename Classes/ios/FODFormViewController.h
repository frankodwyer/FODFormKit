//
//  FODFormViewController.m
//
//  Created by Frank on 29/09/2012.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FODTextInputCell.h"
#import "FODSwitchCell.h"
#import "FODPickerViewController.h"
#import "FODDatePickerViewController.h"
#import "FODForm.h"
#import "FODCellFactory.h"
#import "FODImagePickerCell.h"

@class FODFormViewController;

@protocol FODFormViewControllerDelegate <NSObject>

- (void) formSaved:(FODForm*)form
          userInfo:(id)userInfo;

- (void) formCancelled:(FODForm*)form
              userInfo:(id)userInfo;

@optional
- (void) pickerValueChanged:(NSString*)key
              selectedItems:(NSArray*)selectedItems
                        row:(FODFormRow*)row
       inFormViewController:(FODFormViewController*)form;

// if the validator returns a string, the form will be considered invalid, and the result will be treated as a simple localized error message and displayed.
// if the validator returns @NO, the form will be considered invalid and it will be assumed the delegate handled UI.
// any other result will be treated as meaning the form is valid and the form will be saved.
- (id) validateForm:(FODForm*)form inFormViewController:(FODFormViewController*)formViewController;

@end

@interface FODFormViewController : UIViewController <FODFormCellDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) FODForm *form;
@property (nonatomic, weak) id<FODFormViewControllerDelegate> delegate;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) FODCellFactory *cellFactory;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithForm:(FODForm*)form
           userInfo:(id)userInfo;

@end
