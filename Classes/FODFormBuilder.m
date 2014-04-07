//
//  FODFormBuilder.m
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//  
//  Modified work Copyright 2014 Jonas Stubenrauch, arconsis IT-Solutions GmbH
//

#import "FODFormBuilder.h"
#import "FODSelectionRow.h"

@interface FODFormBuilder ()
@property (nonatomic, strong) NSMutableArray *formStack;
@end

@implementation FODFormBuilder

- (FODForm*) startFormWithTitle:(NSString*)title
                         andKey:(NSString*)key
{

    FODForm *form = [[FODForm alloc] init];
    form.title = title;
    form.key = key;
    if (!self.formStack.count) {
        self.formStack = [NSMutableArray arrayWithObject:form];
    } else {
        form.parentForm = self.formStack.lastObject;
        [self.formStack addObject:form];
    }
    return form;
}

- (FODForm*)startFormWithTitle:(NSString *)title {
    return [self startFormWithTitle:title andKey:nil];
}

- (FODFormSection *)section:(NSString *)title dependency:(NSDictionary *)dependency
{
    FODFormSection *section = [self section:title];
    section.dependency = dependency;
    return section;
}

- (FODFormSection*) section:(NSString*)title {
    FODFormSection *section = [[FODFormSection alloc] initWithForm:self.currentForm];
    section.title = title;
    [self.currentForm.sections addObject:section];
    return section;
}

- (FODFormSection*) section {
    return [self section:nil];
}

- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass
                  andTitle:(NSString*)title
                  andValue:(id)defaultValue
            andPlaceHolder:(NSString*)placeHolder
                dependency:(NSDictionary *)dependency
{
    FODFormRow *row = [self rowWithKey:key ofClass:klass andTitle:title
                              andValue:defaultValue andPlaceHolder:placeHolder];
    row.dependency = dependency;
    return row;
}

- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass
                  andTitle:(NSString*)title
                  andValue:(id)defaultValue
            andPlaceHolder:(NSString *)placeHolder {

    FODFormRow *row = [[klass alloc] init];
    row.title = title;
    row.initialValue = defaultValue;
    row.workingValue = defaultValue;
    row.placeHolder = placeHolder;
    row.key = key;
    row.indexPath = [NSIndexPath indexPathForRow:self.currentSection.rows.count inSection:self.currentForm.sections.count-1];
    [self.currentSection addRow:row];
    return row;
}

- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass
                  andTitle:(NSString*)title
                  andValue:(id)defaultValue {

    return [self rowWithKey:key ofClass:klass andTitle:title andValue:defaultValue andPlaceHolder:nil];
}


- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass
                  andValue:(id)defaultValue {

    return [self rowWithKey:key ofClass:klass andTitle:nil andValue:defaultValue andPlaceHolder:nil];
}

- (FODFormRow*) rowWithKey:(NSString*)key
                   ofClass:(Class)klass {

    return [self rowWithKey:key ofClass:klass andTitle:nil andValue:nil andPlaceHolder:nil];
}

- (FODSelectionRow*) selectionRowWithKey:(NSString*)key
                                andTitle:(NSString*)title
                                andValue:(id)defaultValue
                                andItems:(NSArray*)items {

    FODSelectionRow *row = (FODSelectionRow*)[self rowWithKey:key
                                                      ofClass:[FODSelectionRow class]
                                                     andTitle:title
                                                     andValue:defaultValue];
    row.items = items;
    return row;
}

- (FODForm*) finishForm {
    FODForm *result = self.currentForm;
    [self.formStack removeLastObject];

    if (self.formStack.count >= 1) { // this was a subform, hook it up to parent.
        result.indexPath = [NSIndexPath indexPathForRow:self.currentSection.rows.count
                                              inSection:self.currentForm.sections.count-1];
        [self.currentSection addRow:result];
    }

    return result;
}

- (FODForm*)currentForm {
    return self.formStack.lastObject;
}

- (FODFormSection*)currentSection {
    return [self.currentForm.sections lastObject];
}

@end
