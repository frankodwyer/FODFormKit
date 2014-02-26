//
//  FODInlinePickerCell.h
//  FormKitDemo
//
//  Created by Frank on 01/01/2014.
//  Copyright (c) 2014 Frank O'Dwyer. All rights reserved.
//



#import "FODFormCell.h"

@protocol FODImagePickerCellDelegate <NSObject>

@optional
- (void)imageSelected:(UIImage *)image withUserInfo:(id)userinfo;

@end


@interface FODImagePickerCell : FODFormCell

@end
