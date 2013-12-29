//
//  FODFormSection.h
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FODFormSection : NSObject<NSFastEnumeration>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSMutableArray *rows;

- (id) objectAtIndexedSubscript:(NSInteger)index;

- (NSUInteger) numberOfRows;

@end

