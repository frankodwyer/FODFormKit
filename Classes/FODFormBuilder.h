//
//  FODFormBuilder.h
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//  
//  Modified work Copyright 2014 Jonas Stubenrauch, arconsis IT-Solutions GmbH
//

#import <Foundation/Foundation.h>

#import "FODForm.h"
#import "FODBooleanRow.h"
#import "FODDateSelectionRow.h"
#import "FODSelectionRow.h"
#import "FODTextInputRow.h"
#import "FODSelectionRow.h"

@interface FODFormBuilder : NSObject

- (FODForm*) startFormWithTitle:(NSString*)title;

- (FODForm*) startFormWithTitle:(NSString*)title
                         andKey:(NSString*)key;
- (FODFormSection*) section:(NSString*)title dependency:(NSDictionary *)dependency;
- (FODFormSection*) section:(NSString*)title;

- (FODFormSection*) section;

- (FODSelectionRow*) selectionRowWithKey:(NSString*)key
                                andTitle:(NSString*)title
                                andValue:(id)defaultValue
                                andItems:(NSArray*)items;

- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass
                  andTitle:(NSString*)title
                  andValue:(id)defaultValue
            andPlaceHolder:(NSString*)placeHolder
                dependency:(NSDictionary *)dependency;

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
