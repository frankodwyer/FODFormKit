//
//  FODFormBuilder.h
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FODForm.h"
#import "FODBooleanRow.h"
#import "FODDateSelectionRow.h"
#import "FODSelectionRow.h"
#import "FODTextInputRow.h"

@interface FODFormBuilder : NSObject

- (FODForm*) startFormWithTitle:(NSString*)title;

- (FODForm*) startFormWithTitle:(NSString*)title
                         andKey:(NSString*)key;

- (FODForm*) startFormWithTitle:(NSString*)title
                         andKey:(NSString*)key
                        expands:(BOOL)expands;

- (FODFormSection*) section:(NSString*)title;

- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass
                  andTitle:(NSString*)title
                  andValue:(id)defaultValue
            andPlaceHolder:(NSString*)placeHolder;

- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass
                  andTitle:(NSString*)title
                  andValue:(id)defaultValue;

- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass
                  andValue:(id)defaultValue;

- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass;

- (FODForm*) finishForm;

@end
