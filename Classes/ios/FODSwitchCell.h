//
//  FODSwitchCell.h
//
//  Created by Frank on 30/09/2012.

#import <UIKit/UIKit.h>

#import "FODFormCell.h"

@protocol FODSwitchCellDelegate
- (void) switchValueChangedTo:(BOOL)newValue userInfo:(id)userInfo;
@end

@interface FODSwitchCell : FODFormCell

@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)switchValueChanged:(id)sender;

@end
