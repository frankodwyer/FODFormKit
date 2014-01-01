//
//  FormKitDemoTests.m
//  FormKitDemoTests
//
//  Created by Frank on 26/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "FODFormBuilder.h"
#import "FODForm.h"

@interface FormKitDemoTests : XCTestCase

@property (nonatomic,strong) FODFormBuilder *builder;

@end

@implementation FormKitDemoTests

- (void)setUp
{
    [super setUp];
    self.builder = [[FODFormBuilder alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testPlistLoading1
{
    [self.builder startFormWithTitle:@"Main Form"];

    [self.builder section:@"Section 1"];

    [self.builder rowWithKey:@"foo"
                     ofClass:[FODBooleanRow class]
                    andTitle:@"Foo option"
                    andValue:@YES];

    [self.builder section];

    [self.builder rowWithKey:@"bar"
                     ofClass:[FODTextInputRow class]
                    andTitle:@"Bar"
                    andValue:@"bar"
              andPlaceHolder:@"Fooby baz"];
    [self.builder rowWithKey:@"date"
                     ofClass:[FODDateSelectionRow class]
                    andTitle:@"When"
                    andValue:nil];

    { // start subform
        [self.builder startFormWithTitle:@"Sub Form"
                                  andKey:@"subform"];

        [self.builder section:@"Section 1"];

        [self.builder rowWithKey:@"foo"
                         ofClass:[FODBooleanRow class]
                        andTitle:@"Foo option"
                        andValue:@NO];
        [self.builder rowWithKey:@"bar"
                         ofClass:[FODTextInputRow class]
                        andTitle:@"Bar"
                        andValue:@"bar"
                  andPlaceHolder:@"Fooby baz"];
        for (int i = 0 ; i < 4; i++) {
            NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
            [self.builder rowWithKey:foobar
                             ofClass:[FODTextInputRow class]
                            andTitle:nil
                            andValue:foobar
                      andPlaceHolder:@"Fooby baz"];
        }
        [self.builder rowWithKey:@"date" ofClass:[FODDateSelectionRow class]
                   andTitle:@"When"
                   andValue:nil];

        [self.builder finishForm];
    } // finish subform

    for (int i = 0 ; i < 3; i++) {
        NSString *foobar = [NSString stringWithFormat:@"foobar%@", @(i)];
        [self.builder rowWithKey:foobar
                    ofClass:[FODTextInputRow class]
                   andTitle:nil
                   andValue:foobar
             andPlaceHolder:@"Fooby baz"];
    }
    
    FODForm *form = [self.builder finishForm];
    FODForm *fromPlist = [FODForm fromPlist:form.toPlist];

    XCTAssertTrue([fromPlist.toPlist isEqual:form.toPlist], @"Serialization to and from plist doesn't yield the same form");
}

- (void)testPlistLoading2
{
    [self.builder startFormWithTitle:@"Main Form"];

    [self.builder section:@"Section 1"];

    [self.builder selectionRowWithKey:@"picker"
                             andTitle:@"Select a wibble"
                             andValue:nil
                             andItems:@[@"wibble1", @"wibble2", @"wibble3"]];

    [self.builder selectionRowWithKey:@"picker2"
                             andTitle:@"Select a fooby"
                             andValue:nil
                             andItems:@[@"fooby1", @"fooby2", @"fooby3"]].displayInline = YES;

    [self.builder section];

    [self.builder rowWithKey:@"date2"
                     ofClass:[FODDateSelectionRow class]
                    andTitle:@"When"
                    andValue:nil];
    [self.builder rowWithKey:@"date1"
                     ofClass:[FODDateSelectionRow class]
                    andTitle:@"When Inline"
                    andValue:nil].displayInline = YES;
    
    FODForm *form = [self.builder finishForm];

    FODForm *fromPlist = [FODForm fromPlist:form.toPlist];

    XCTAssertTrue([fromPlist.toPlist isEqual:form.toPlist], @"Serialization to and from plist doesn't yield the same form");
}

@end
