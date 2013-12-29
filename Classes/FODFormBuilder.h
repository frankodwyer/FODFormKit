//
//  FODFormBuilder.h
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FODFormModel.h"
#import "FODBooleanRow.h"
#import "FODDateSelectionRow.h"
#import "FODSelectionRow.h"
#import "FODTextInputRow.h"

@interface FODFormBuilder : NSObject

- (void) startFormWithTitle:(NSString*)title;

- (void) startSection:(NSString*)title;

- (void) startRow:(NSString*)key
          ofClass:(Class)klass
        withTitle:(NSString*)title
     defaultValue:(id)defaultValue;

- (void) startRow:(NSString*)key
          ofClass:(Class)klass
     defaultValue:(id)defaultValue;

- (void) startRow:(NSString*)key
          ofClass:(Class)klass;

- (void) addSubform:(FODFormModel*)form;

- (FODFormModel*) finishForm;

@end
