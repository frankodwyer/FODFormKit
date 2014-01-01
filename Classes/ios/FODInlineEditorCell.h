//
//  FODInlineEditorCell.h
//  FormKitDemo
//
//  Created by Frank on 01/01/2014.
//  Copyright (c) 2014 Frank O'Dwyer. All rights reserved.
//

#import "FODExpandingCell.h"

@interface FODInlineEditorCell : FODExpandingCell

@property (strong,nonatomic) UIViewController *editorController;

// subclasses override
- (UIViewController*) createEditorController;
- (CGFloat) heightForEditorController:(CGFloat)maxHeight;

@end
