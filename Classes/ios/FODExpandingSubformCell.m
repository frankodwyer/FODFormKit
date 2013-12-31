//
//  FODExpandingSubformCell.m
//  FormKitDemo
//
//  Created by frank on 12/30/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODExpandingSubformCell.h"
#import "FODForm.h"

@interface FODExpandingSubformCell ()

@end

@implementation FODExpandingSubformCell

- (void)configureCellForRow:(FODFormRow *)row withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    self.titleLabel.text = row.title;
}

- (void) setExpanded:(BOOL)expanded {
    [super setExpanded:expanded];
    if (self.expanded) {
        [self addAllFormRowsToParentForm];
    } else {
        [self removeAllFormRowsFromParentForm];
    }
}

- (FODForm*)form {
    return (FODForm*)self.row;
}

- (UITableView*)tableView {
    return (UITableView*) self.superview.superview;
}

- (void) addAllFormRowsToParentForm {
    [self.tableView beginUpdates];
    NSArray *expandedIndexPaths = [self.form.parentForm insertRowsFromSubform:self.form];
    [self.tableView insertRowsAtIndexPaths:expandedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

}

- (void) removeAllFormRowsFromParentForm {
    [self.tableView beginUpdates];
    NSArray *collapsedIndexPaths = [self.form.parentForm removeRowsFromSubform:self.form];
    [self.tableView deleteRowsAtIndexPaths:collapsedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
