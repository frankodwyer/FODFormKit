//
//  FODDatePickerViewController.m
//  bigpicture
//
//  Created by frank on 5/26/13.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODDatePickerViewController.h"
#import "NSDate+Dateutils.h"

@interface FODDatePickerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSDate *selectedItem;

@property (nonatomic) NSDate *today;

- (void)savePressed:(id)sender;

@end

@implementation FODDatePickerViewController

- (id)init
{
    self = [super init];
    if (self) {
        /*_shortCutItems = @[
                               NSLocalizedString(@"Yesterday", @"Label in date picker"),
                               NSLocalizedString(@"Today", @"Label in date picker"),
                               NSLocalizedString(@"Tomorrow", @"Label in date picker"),
                               ];
                               */
        _today = [NSDate date].fod_startOfDay;
        /*
        _shortCutDates = @[
                               [_today fod_dateByAddingDays:-1],
                               _today,
                               [_today fod_dateByAddingDays:1],
                               ];
                               */

    }
    return self;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(savePressed:)];

    if (!self.shortCutItems.count || !self.shortCutDates.count) {
        [self.tableView removeFromSuperview];
    }

    [self.datePicker addTarget:self
                        action:@selector(dateChanged:)
              forControlEvents:UIControlEventValueChanged];

    if (self.startValue) {
        [self.datePicker setDate:[self.startValue fod_startOfDay] animated:NO];
        self.navigationItem.rightBarButtonItem.enabled = NO;        
    } else {
        [self.datePicker setDate:self.today animated:NO];
    }
}

- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}

- (void) dateChanged:(id)sender {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (self.usedInline) {
        [self savePressed:self];
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shortCutItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }

    [self.shortCutDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self.datePicker.date isEqualToDate:obj]) {
            self.selectedItem = self.shortCutItems[idx];
            *stop = YES;
        }
    }];

    cell.textLabel.text = self.shortCutItems[indexPath.row];

    if ([self.selectedItem isEqual:self.shortCutItems[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedItem = self.shortCutItems[indexPath.row];
    [self.datePicker setDate:self.shortCutDates[indexPath.row]
                    animated:YES];
    [self dateChanged:self];
}

- (void)savePressed:(id)sender {
    [self.delegate dateSelected:self.datePicker.date
                       userInfo:self.userInfo];
}

@end
