//
//  FODFormRow.h
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//  
//  Modified work Copyright 2014 Thimo Bess, arconsis IT-Solutions GmbH 
//  Modified work Copyright 2014 Jonas Stubenrauch, arconsis IT-Solutions GmbH 
//

#import <Foundation/Foundation.h>

@class FODForm;
@class FODFormBuilder;

@interface FODFormRow : NSObject<NSCopying>

@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSIndexPath *indexPath;

@property (nonatomic) NSDictionary *dependency;
@property (nonatomic) BOOL hidden;

@property (nonatomic,readonly) BOOL isEditable;
@property (nonatomic,copy) id<NSCopying> initialValue;
@property (nonatomic,copy) id<NSCopying> workingValue;
@property (nonatomic,copy) id<NSCopying> placeHolder;
@property (nonatomic,assign) BOOL expanded;
@property (nonatomic,strong) NSMutableDictionary *viewState;
@property (nonatomic,assign) BOOL displayInline; // display the editor or subform inline if possible

+(CGFloat)defaultHeight;

// serializes to a property list format (array or dictionary)
- (id) toPlist;

- (NSDictionary *)extractValues;
- (void)applyValue:(id)value;

// constructs from an in memory plist
+ (FODFormRow*) fromPlist:(id)plist
              withBuilder:(FODFormBuilder*)builder;

@end

