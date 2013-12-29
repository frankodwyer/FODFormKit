//
//  FODSwitchCell.m
//  fodUIKit
//
//  Created by Frank on 30/09/2012.
//  Copyright (c) 2012 Desirepath. All rights reserved.
//

#import "FODSwitchCell.h"

@implementation FODSwitchCell

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate switchValueChangedTo:self.switchControl.on userInfo:self.row];
}

- (void) configureCellForRow:(FODFormRow*)row
                withDelegate:(id)delegate {
    [super configureCellForRow:row withDelegate:delegate];
    self.delegate = delegate;
    self.switchControl.on = [(NSNumber*)row.workingValue boolValue];
    self.titleLabel.text = row.title;
}

@end
