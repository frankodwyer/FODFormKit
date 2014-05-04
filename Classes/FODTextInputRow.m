//
//  FODTextInputRow.m
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//
//  Modified work Copyright 2014 Jonas Stubenrauch, arconsis IT-Solutions GmbH
//

#import "FODTextInputRow.h"

@implementation FODTextInputRow

- (BOOL)isEditable {
    return YES;
}

+ (CGFloat)defaultHeight
{
    return self.frame.height;
}

@end
