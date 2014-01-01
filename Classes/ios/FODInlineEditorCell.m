//
//  FODInlineEditorCell.m
//  FormKitDemo
//
//  Created by Frank on 01/01/2014.
//  Copyright (c) 2014 Frank O'Dwyer. All rights reserved.
//

#import "FODInlineEditorCell.h"
#import "FODFormViewController.h"

#define DEFAULT_EDITOR_HEIGHT (390.0)

@interface FODInlineEditorCell ()
@end


@implementation FODInlineEditorCell

- (void)configureCellForRow:(FODFormRow *)row
               withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];
    self.expanded = row.expanded;
    if (self.expanded) {
        self.editorController = [self createEditorController];
        self.editorController.view.frame = CGRectMake(0,self.tableView.rowHeight, self.bounds.size.width,[self heightForEditorController:DEFAULT_EDITOR_HEIGHT]);
        [self.contentView addSubview:self.editorController.view];
        [self.formViewController addChildViewController:self.editorController];
        [self.editorController didMoveToParentViewController:self.formViewController];
    } else {
        self.editorController = nil;
    }
}

// subclasses provide this
- (UIViewController*)createEditorController {
    return nil;
}

- (CGFloat) heightForEditorController:(CGFloat)maxHeight {
    return maxHeight;
}

- (void) setExpanded:(BOOL)expanded {
    [super setExpanded:expanded];
    if (self.expanded) {
        [self.delegate adjustHeight:[self heightForEditorController:DEFAULT_EDITOR_HEIGHT]+self.tableView.rowHeight
                  forRowAtIndexPath:self.row.indexPath];
    } else {
        [self.delegate adjustHeight:self.tableView.rowHeight
                  forRowAtIndexPath:self.row.indexPath];
    }
}

- (void) removeEditorController:(UIViewController*)vc {
    if (vc) {
        [vc.view removeFromSuperview];
        [vc willMoveToParentViewController:nil];
        [vc removeFromParentViewController];
    }
}

// we need to hold the date picker state in the row model in case of cell reuse/allocation
- (void) setEditorController:(UIViewController *)editorController {
    UIViewController *previousValue = self.editorController;

    if (editorController) {
        self.row.viewState[@"editorController"] = editorController;
    } else {
        [self.row.viewState removeObjectForKey:@"editorController"];
    }

    if (previousValue) {
        [self removeEditorController:previousValue];
    }
}

- (UIViewController *)editorController {
    return self.row.viewState[@"editorController"];
}


@end
