//
//  FODDatePickerViewController.h
//  bigpicture
//
//  Created by frank on 5/26/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FODDatePickerDelegate <NSObject>
- (void) dateSelected:(NSDate*)date
             userInfo:(id)userInfo;
@end

@interface FODDatePickerViewController : UIViewController

@property (weak, nonatomic) id<FODDatePickerDelegate> delegate;

@property (nonatomic,assign) BOOL usedInline;
@property (strong, nonatomic) NSDate *startValue;
@property (strong, nonatomic) id userInfo;
@property (strong, nonatomic) NSArray *shortCutItems;
@property (strong, nonatomic) NSArray *shortCutDates;

@end
