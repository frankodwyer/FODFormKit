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

@interface FODViewController ()<FODDatePickerDelegate>

@end

@implementation FODViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    FODFormBuilder *builder = [[FODFormBuilder alloc] init];

    [builder startFormWithTitle:@"Main Form"];
    [builder startSection:@"Section 1"];
    [builder startRow:@"foo" ofClass:[FODBooleanRow class] withTitle:@"Foo option" defaultValue:@YES];
    [builder startRow:@"bar" ofClass:[FODTextInputRow class] withTitle:@"Bar" defaultValue:@"bar"];

    [builder startFormWithTitle:@"Sub Form"];
    [builder startSection:@"Section 1"];
    [builder startRow:@"foo" ofClass:[FODBooleanRow class] withTitle:@"Foo option" defaultValue:@NO];
    [builder startRow:@"bar" ofClass:[FODTextInputRow class] withTitle:@"Bar" defaultValue:@"bar"];
    for (int i = 0 ; i < 20; i++) {
        NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
        [builder startRow:foobar ofClass:[FODTextInputRow class] withTitle:nil defaultValue:foobar];
    }
    [builder startRow:@"date" ofClass:[FODDateSelectionRow class] withTitle:@"When" defaultValue:nil];
    FODFormModel *subform = [builder finishForm];
    [builder addSubform:subform];
    
    for (int i = 0 ; i < 20; i++) {
        NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
        [builder startRow:foobar ofClass:[FODTextInputRow class] withTitle:nil defaultValue:foobar];
    }
    [builder startRow:@"date" ofClass:[FODDateSelectionRow class] withTitle:@"When" defaultValue:nil];
    FODFormModel *form = [builder finishForm];

    //    FODFormViewController *vc = [[FODFormViewController alloc] initWithStyle:UITableViewStyleGrouped andModel:form userInfo:nil];
    FODFormViewController *vc = [[FODFormViewController alloc] initWithModel:form userInfo:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dateSelected:(NSDate*)date
             userInfo:(id)userInfo {

}

@end
