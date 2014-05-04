//
//  FODInlinePickerCell.h
//  FormKitDemo
//
//  Copyright 2014 Thimo Bess, arconsis IT-Solutions GmbH
//



#import "FODFormCell.h"

@protocol FODImagePickerCellDelegate <NSObject>
@optional
- (void)imageSelected:(UIImage *)image withUserInfo:(id)userinfo;
@end


@interface FODImagePickerCell : FODFormCell

@end
