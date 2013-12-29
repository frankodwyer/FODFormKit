//
//  FODTextInputCell.h
//  fodUIKit
//
//  Created by Frank on 30/09/2012.
//  Copyright (c) 2012 Desirepath. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FODFormCell.h"

@protocol FODSwitchCellDelegate
- (void) switchValueChangedTo:(BOOL)newValue userInfo:(id)userInfo;
@end

@interface FODSwitchCell : FODFormCell

@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) id<FODSwitchCellDelegate> delegate;

- (IBAction)switchValueChanged:(id)sender;

@end
