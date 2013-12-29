//
//  FODFormBuilder.m
//  FormKitDemo
//
//  Created by Frank on 28/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODFormBuilder.h"

@interface FODFormBuilder ()
@property (nonatomic, strong) NSMutableArray *models;
@end

@implementation FODFormBuilder

- (void) startSubformWithTitle:(NSString*)title
                        andKey:(NSString*)key {
    FODFormModel *form = [[FODFormModel alloc] init];
    form.title = title;
    form.key = key;
    if (!self.models.count) {
        self.models = [NSMutableArray arrayWithObject:form];
    } else {
        form.parentForm = self.models.lastObject;
        [self.models addObject:form];
    }
}

- (void) startFormWithTitle:(NSString *)title {
    [self startSubformWithTitle:title andKey:nil];
}

- (FODFormModel*)currentModel {
    return self.models.lastObject;
}

- (FODFormSection*)currentSection {
    return [self.currentModel.sections lastObject];
}

- (void) startSection:(NSString*)title {
    FODFormSection *section = [[FODFormSection alloc] init];
    section.title = title;
    [self.currentModel.sections addObject:section];
}

- (void) startRow:(NSString*)key
          ofClass:(Class)klass
        withTitle:(NSString*)title
     defaultValue:(id)defaultValue
      placeHolder:(NSString *)placeHolder{

    FODFormRow *row = [[klass alloc] init];
    row.title = title;
    row.initialValue = defaultValue;
    row.workingValue = defaultValue;
    row.placeHolder = placeHolder;
    row.key = key;
    row.indexPath = [NSIndexPath indexPathForRow:self.currentSection.rows.count inSection:self.currentModel.sections.count-1];
    [self.currentSection.rows addObject:row];
}

- (void) startRow:(NSString*)key
          ofClass:(Class)klass
        withTitle:(NSString*)title
     defaultValue:(id)defaultValue {
    [self startRow:key ofClass:klass withTitle:title defaultValue:defaultValue placeHolder:nil];
}


- (void)addSubform:(FODFormModel *)form {
    form.indexPath = [NSIndexPath indexPathForRow:self.currentSection.rows.count inSection:self.currentModel.sections.count-1];
    [self.currentSection.rows addObject:form];
}

- (void) startRow:(NSString*)key
          ofClass:(Class)klass
     defaultValue:(id)defaultValue {
    [self startRow:key ofClass:klass withTitle:nil defaultValue:defaultValue placeHolder:nil];
}

- (void) startRow:(NSString*)key
          ofClass:(Class)klass {
    [self startRow:key ofClass:klass withTitle:nil defaultValue:nil placeHolder:nil];
}

- (FODFormModel*) finishForm {
    FODFormModel *result = self.currentModel;
    [self.models removeLastObject];
    return result;
}


@end
