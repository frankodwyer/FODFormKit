//
//  FODViewController.m
//  FormKitDemo
//
//  Created by Frank on 26/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODViewController.h"

#import "FODFormViewController.h"
#import "FODFormBuilder.h"
#import "FODForm.h"

@interface FODViewController()<FODFormViewControllerDelegate>

@end


@implementation FODViewController

- (IBAction)formWithSubform:(id)sender {
    FODFormBuilder *builder = [[FODFormBuilder alloc] init];

    [builder startFormWithTitle:@"Main Form"];
    [builder section:@"Section 1"];
    [builder rowWithKey:@"foo" ofClass:[FODBooleanRow class] andTitle:@"Foo option" andValue:@YES];
    [builder section:nil];
    [builder rowWithKey:@"bar" ofClass:[FODTextInputRow class] andTitle:@"Bar" andValue:@"bar" andPlaceHolder:@"Fooby baz"];
    [builder rowWithKey:@"date" ofClass:[FODDateSelectionRow class] andTitle:@"When" andValue:nil];

    { // start subform
        [builder startFormWithTitle:@"Sub Form" andKey:@"subform"];
        [builder section:@"Section 1"];
        [builder rowWithKey:@"foo" ofClass:[FODBooleanRow class] andTitle:@"Foo option" andValue:@NO];
        [builder rowWithKey:@"bar" ofClass:[FODTextInputRow class] andTitle:@"Bar" andValue:@"bar" andPlaceHolder:@"Fooby baz"];
        for (int i = 0 ; i < 4; i++) {
            NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
            [builder rowWithKey:foobar ofClass:[FODTextInputRow class] andTitle:nil andValue:foobar andPlaceHolder:@"Fooby baz"];
        }
        [builder rowWithKey:@"date" ofClass:[FODDateSelectionRow class] andTitle:@"When" andValue:nil].displayInline = YES;
        [builder finishForm];
    } // finish subform

    for (int i = 0 ; i < 10; i++) {
        NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
        [builder rowWithKey:foobar ofClass:[FODTextInputRow class] andTitle:nil andValue:foobar andPlaceHolder:@"Fooby baz"];
    }

    [builder section:nil];

    for (int i = 10 ; i < 20; i++) {
        NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
        [builder rowWithKey:foobar ofClass:[FODTextInputRow class] andTitle:nil andValue:foobar andPlaceHolder:@"Fooby baz"];
    }

    FODForm *form = [builder finishForm];

    NSLog(@"Form:%@", form.toPlist);

    NSLog(@"Form to and from plist passes test? %@", @([[[FODForm fromPlist:form.toPlist] toPlist] isEqual:form.toPlist]));
    FODFormViewController *vc = [[FODFormViewController alloc] initWithForm:form userInfo:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)formWithExpandingSubform:(id)sender {
    FODFormBuilder *builder = [[FODFormBuilder alloc] init];

    [builder startFormWithTitle:@"Main Form"];
    [builder section:@"Section 1"];
    [builder rowWithKey:@"foo" ofClass:[FODBooleanRow class] andTitle:@"Foo option" andValue:@YES];

    FODSelectionRow *row = (FODSelectionRow*)[builder rowWithKey:@"picker" ofClass:[FODSelectionRow class] andTitle:@"Select a wibble" andValue:nil];
    row.items = @[@"wibble1", @"wibble2", @"wibble3"];

    FODSelectionRow *row2 = (FODSelectionRow*)[builder rowWithKey:@"picker2" ofClass:[FODSelectionRow class] andTitle:@"Select a fooby" andValue:nil];
    row2.items = @[@"fooby1", @"fooby2", @"fooby3"];
    row2.displayInline = YES;
    [builder section:nil];
    [builder rowWithKey:@"bar" ofClass:[FODTextInputRow class] andTitle:@"Bar" andValue:@"bar" andPlaceHolder:@"Fooby baz"];
    [builder rowWithKey:@"date" ofClass:[FODDateSelectionRow class] andTitle:@"When Inline" andValue:nil].displayInline = YES;
    [builder rowWithKey:@"date2" ofClass:[FODDateSelectionRow class] andTitle:@"When" andValue:nil];

    [builder section:nil];

    { // start subform
        [builder startFormWithTitle:@"Advanced" andKey:@"advanced"].displayInline = YES;
        [builder section:@"Section 1"];
        [builder rowWithKey:@"advanced_foo" ofClass:[FODBooleanRow class] andTitle:@"Foo option" andValue:@NO];
        [builder rowWithKey:@"advanced_bar" ofClass:[FODTextInputRow class] andTitle:@"Bar" andValue:@"bar" andPlaceHolder:@"Fooby baz"];
        [builder finishForm];
    } // finish subform

    [builder rowWithKey:@"date3" ofClass:[FODDateSelectionRow class] andTitle:@"When" andValue:nil];
    [builder section:nil];

    for (int i = 0 ; i < 10; i++) {
        NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
        [builder rowWithKey:foobar ofClass:[FODTextInputRow class] andTitle:nil andValue:foobar andPlaceHolder:@"Fooby baz"];
    }

    [builder section:nil];

    for (int i = 10 ; i < 20; i++) {
        NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
        [builder rowWithKey:foobar ofClass:[FODTextInputRow class] andTitle:nil andValue:foobar andPlaceHolder:@"Fooby baz"];
    }

    FODForm *form = [builder finishForm];

    NSLog(@"Form:%@", form.toPlist);

    NSLog(@"Form to and from plist passes test? %@", @([[[FODForm fromPlist:form.toPlist] toPlist] isEqual:form.toPlist]));
    FODFormViewController *vc = [[FODFormViewController alloc] initWithForm:form userInfo:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)formSaved:(FODForm *)model
         userInfo:(id)userInfo {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)formCancelled:(FODForm *)model
             userInfo:(id)userInfo {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
