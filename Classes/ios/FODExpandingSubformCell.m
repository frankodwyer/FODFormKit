//
//  FODExpandingSubformCell.m
//  FormKitDemo
//
//  Created by frank on 12/30/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODExpandingSubformCell.h"
#import "FODForm.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface FODExpandingSubformCell ()

@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (nonatomic,assign) CGFloat rotation;
@property (nonatomic,assign) CGPoint translation;
@property (nonatomic,assign) BOOL expanded;

@end

@implementation FODExpandingSubformCell

- (void)configureCellForRow:(FODFormRow *)row withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    self.titleLabel.text = row.title;
}

- (void) setRotation:(CGFloat)rotation {
    _rotation = rotation;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(self.translation.x, self.translation.y);
    transform = CGAffineTransformRotate(transform, DegreesToRadians(rotation));
    transform = CGAffineTransformTranslate(transform,-self.translation.x,-self.translation.y);
    self.arrowLabel.transform = transform;
}

- (void)cellAction:(UINavigationController *)navController {
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.5];
    if (self.rotation == 0) {
        self.translation = CGPointMake(0, 5);
        self.rotation = 180;
        self.expanded = YES;
    } else {
        self.translation = CGPointMake(0, -5);
        self.rotation = 0;
        self.expanded = NO;
    }
    [UIView commitAnimations];

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
