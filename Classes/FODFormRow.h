//
//  FODFormRow.h
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FODFormRow : NSObject

@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSIndexPath *indexPath;

@property (nonatomic,copy) id<NSCopying> initialValue;
@property (nonatomic,copy) id<NSCopying> workingValue;
@property (nonatomic,copy) id<NSCopying> placeHolder;

@end

