//
//  FODExpandingCell.m
//  FormKitDemo
//
//  Created by frank on 12/31/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODExpandingCell.h"
#import "FODCellFactory.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface FODExpandingCell ()

@property (nonatomic,assign) CGFloat rotation;
@property (nonatomic,assign) CGPoint translation;

@end


@implementation FODExpandingCell

- (void)configureCellForRow:(FODFormRow *)row withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    self.titleLabel.text = row.title;
    self.valueLabel.textColor = [FODCellFactory editableItemColor];
}

- (void)cellAction:(UINavigationController *)navController {
    self.expanded = !self.expanded;
}

- (void) setExpanded:(BOOL)expanded {
    _expanded = expanded;
    self.row.expanded = expanded;
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.5];
    if (expanded) {
        self.translation = CGPointMake(0, 5);
        self.rotation = 180;
    } else {
        self.translation = CGPointMake(0, -5);
        self.rotation = 0;
    }
    [UIView commitAnimations];
}

- (void) setRotation:(CGFloat)rotation {
    _rotation = rotation;
    CGAffineTransform transform = CGAffineTransformMakeTranslation(self.translation.x, self.translation.y);
    transform = CGAffineTransformRotate(transform, DegreesToRadians(rotation));
    transform = CGAffineTransformTranslate(transform,-self.translation.x,-self.translation.y);
    self.arrowLabel.transform = transform;
}

@end
