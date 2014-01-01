//
//  FODPickerViewController.h
//
//  Created by Frank on 30/09/2012.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FODPickerViewControllerDelegate
- (void) selectionMade:(NSArray*)selectedItems userInfo:(id)userInfo;
@end

@interface FODPickerViewController : UITableViewController

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSArray *initialSelection;
@property (nonatomic,assign) BOOL multipleSelection;
@property (nonatomic,strong) id userInfo;
@property (nonatomic, weak) id<FODPickerViewControllerDelegate> delegate;

@end
