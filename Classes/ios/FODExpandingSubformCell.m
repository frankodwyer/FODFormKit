//
//  FODExpandingSubformCell.m
//  FormKitDemo
//
//  Created by frank on 12/30/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODExpandingSubformCell.h"

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@interface FODExpandingSubformCell ()

@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (nonatomic,assign) CGFloat rotation;

@end

@implementation FODExpandingSubformCell

- (void)configureCellForRow:(FODFormRow *)row withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    self.titleLabel.text = row.title;
}

- (void)cellAction:(UINavigationController *)navController {
    [UIView beginAnimations:@"rotate" context:nil];
    [UIView setAnimationDuration:0.5];
    if (self.rotation == 0) {
        CGFloat x=0,y=5;
        self.rotation = 180;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
        transform = CGAffineTransformRotate(transform, DegreesToRadians(self.rotation));
        transform = CGAffineTransformTranslate(transform,-x,-y);
        self.arrowLabel.transform = transform;
    } else {
        CGFloat x=0,y=-5;
        self.rotation = 0;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
        transform = CGAffineTransformRotate(transform, DegreesToRadians(self.rotation));
        transform = CGAffineTransformTranslate(transform,-x,-y);
        self.arrowLabel.transform = transform;
    }
    [UIView commitAnimations];
}

@end
