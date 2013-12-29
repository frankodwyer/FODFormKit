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
#import "FODFormModel.h"

@interface FODViewController()<FODFormViewControllerDelegate>

@end


@implementation FODViewController

- (IBAction)formWithSubform:(id)sender {
    FODFormBuilder *builder = [[FODFormBuilder alloc] init];

    [builder startFormWithTitle:@"Main Form"];
    [builder startSection:@"Section 1"];
    [builder startRow:@"foo" ofClass:[FODBooleanRow class] withTitle:@"Foo option" defaultValue:@YES];
    [builder startRow:@"bar" ofClass:[FODTextInputRow class] withTitle:@"Bar" defaultValue:@"bar" placeHolder:@"Fooby baz"];

    [builder startSubformWithTitle:@"Sub Form" andKey:@"subform"];
    [builder startSection:@"Section 1"];
    [builder startRow:@"foo" ofClass:[FODBooleanRow class] withTitle:@"Foo option" defaultValue:@NO];
    [builder startRow:@"bar" ofClass:[FODTextInputRow class] withTitle:@"Bar" defaultValue:@"bar" placeHolder:@"Fooby baz"];
    for (int i = 0 ; i < 4; i++) {
        NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
        [builder startRow:foobar ofClass:[FODTextInputRow class] withTitle:nil defaultValue:foobar placeHolder:@"Fooby baz"];
    }
    [builder startRow:@"date" ofClass:[FODDateSelectionRow class] withTitle:@"When" defaultValue:nil];
    FODFormModel *subform = [builder finishForm];
    [builder addSubform:subform];

    for (int i = 0 ; i < 20; i++) {
        NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
        [builder startRow:foobar ofClass:[FODTextInputRow class] withTitle:nil defaultValue:foobar placeHolder:@"Fooby baz"];
    }
    [builder startRow:@"date" ofClass:[FODDateSelectionRow class] withTitle:@"When" defaultValue:nil];
    FODFormModel *form = [builder finishForm];

    //    FODFormViewController *vc = [[FODFormViewController alloc] initWithStyle:UITableViewStyleGrouped andModel:form userInfo:nil];
    FODFormViewController *vc = [[FODFormViewController alloc] initWithModel:form userInfo:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)formSaved:(FODFormModel *)model
         userInfo:(id)userInfo {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)formCancelled:(FODFormModel *)model
             userInfo:(id)userInfo {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
