//
//  FODInlinePickerCell.m
//  FormKitDemo
//
//  Created by Frank on 01/01/2014.
//  Copyright (c) 2014 Frank O'Dwyer. All rights reserved.
//

#import "FODInlinePickerCell.h"
#import "FODPickerViewController.h"
#import "FODSelectionRow.h"

@interface FODInlinePickerCell ()<FODPickerViewControllerDelegate>
@end


@implementation FODInlinePickerCell

- (void)configureCellForRow:(FODFormRow *)row
               withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];
    self.valueLabel.text = (NSString*)row.workingValue;
}

- (UIViewController *)createEditorController {
    FODPickerViewController *vc = [[FODPickerViewController alloc] init];
    vc.userInfo = self.row;
    vc.delegate = self;
    vc.items = ((FODSelectionRow*)self.row).items;
    vc.title = self.row.title;
    if (self.row.workingValue) {
        vc.initialSelection = @[self.row.workingValue];
    }
    return vc;
}

- (CGFloat)heightForEditorController:(CGFloat)maxHeight {
    return ((FODSelectionRow*)self.row).items.count * self.tableView.rowHeight;
}

- (void) selectionMade:(NSArray*)selectedItems userInfo:(id)userInfo {
    self.valueLabel.text = selectedItems[0];
}

@end
