//
//  FODInlinePickerCell.m
//  FormKitDemo
//
//  Created by Frank on 01/01/2014.
//  Copyright (c) 2014 Frank O'Dwyer. All rights reserved.
//

#import "FODImagePickerCell.h"
#import "FODSwitchCell.h"


@interface FODImagePickerCell ()  <FODFormCellDelegate>

@property (strong, nonatomic) IBOutlet UILabel *title;

@end


@implementation FODImagePickerCell

- (void)configureCellForRow:(FODFormRow *)row withDelegate:(id)delegate {

    [super configureCellForRow:row withDelegate:delegate];

    self.title.text = row.title;

    [self.delegate adjustHeight:120.0 forRowAtIndexPath:self.row.indexPath];
}

- (void)cellAction:(UINavigationController *)navController
{
    [super cellAction:navController];
}

@end
