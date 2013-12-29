//
//  FODDynamicTableViewController.m
//  fodUIKit
//
//  Created by Frank on 29/09/2012.
//  Copyright (c) 2012 Desirepath. All rights reserved.
//


#import "FODFormViewController.h"

#import "FODFormModel.h"
#import "FODDateSelectionRow.h"
#import "FODSelectionRow.h"
#import "FODTextInputRow.h"

#import "FODTextInputCell.h"
#import "FODSwitchCell.h"
#import "FODDatePickerViewController.h"
#import "FODPickerCell.h"
#import "FODDatePickerCell.h"

@interface FODFormViewController ()

@property (nonatomic) UIToolbar *toolbar;
@property (nonatomic) UIBarButtonItem *prevButton; // previous button on toolbar
@property (nonatomic) UIBarButtonItem *nextButton; // next button on toolbar
@property (nonatomic) NSIndexPath *currentlyEditingIndexPath;
@property (nonatomic) BOOL programmaticallyTransitioningCurrentEdit;
@property (nonatomic, readonly) UITextField *currentlyEditingField;
@property (nonatomic) NSMutableDictionary *textFields;
@end

@implementation UIView(FOD)

- (UIView *)fod_findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }

    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView fod_findFirstResponder];

        if (firstResponder != nil) {
            return firstResponder;
        }
    }

    return nil;
}

@end

@implementation NSIndexPath(FOD)

// convert an index path to a key that should be suitable for NSDictionary even if a subclass doesn't implement isEqual/hash correctly.
- (NSString*)fod_indexPathKey
{
    return [NSString stringWithFormat:@"%@.%@", @(self.section), @(self.row)];
}

@end


@interface FODFormViewController()

@property (nonatomic) BOOL keyboardIsComingUp;

@end


@implementation FODFormViewController

- (id)initWithModel:(FODFormModel*)model
           userInfo:(id)userInfo
{
    self = [super init];
    if (self) {
        _model = model;
        _userInfo = userInfo;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Button label")
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(savePressed:)];

    if (!self.model.parentForm) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:NSLocalizedString(@"Cancel", @"Button label")
                                                 style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(cancelPressed:)];
    }

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.cellFactory = [[FODCellFactory alloc] initWithTableView:self.tableView];
    [self.view addSubview:self.tableView];
    
    // create a toolbar to go above the textfield keyboard with previous/next navigators.
    self.toolbar= [[UIToolbar alloc] init];
    [self.toolbar sizeToFit];
    self.prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(moveToPrevField:)];
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(moveToNextField:)];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [self.toolbar setItems:@[flexButton, self.prevButton, self.nextButton]];

    self.textFields = [NSMutableDictionary dictionary];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)setModel:(FODFormModel *)model {
    if (_model != model) {
        _model = model;
        [self.tableView reloadData];
    }
}

#pragma mark handle moving from one text field to another

- (BOOL) isEditableAtIndexPath:(NSIndexPath*)indexPath {
    return [self.model[indexPath] isKindOfClass:[FODTextInputRow class]];
}

- (void) scrollToCurrentlyEditingIndexPath {
    if (!self.currentlyEditingIndexPath) {
        return;
    }
    CGRect currentCellRect = [self.tableView rectForRowAtIndexPath:self.currentlyEditingIndexPath];
    CGFloat currentCellRectMiddleY = currentCellRect.origin.y + currentCellRect.size.height/2;
    CGFloat visRectHeight = self.tableView.frame.size.height - self.tableView.contentInset.bottom - self.tableView.contentInset.top;

    CGFloat newOffsetY = currentCellRectMiddleY - visRectHeight/2 - self.tableView.contentInset.top;

    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.contentOffset = CGPointMake(0, newOffsetY);
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.programmaticallyTransitioningCurrentEdit) {
                [self makeCurrentlyEditingFieldFirstResponder];
                self.programmaticallyTransitioningCurrentEdit = NO;
            }
        }
    }];
}

- (void)setCurrentlyEditingIndexPath:(NSIndexPath *)currentlyEditing {
    // do nothing if we're already editing this field
    if (_currentlyEditingIndexPath == currentlyEditing) {
        return;
    }

    // update ivar and *afterwards* resign the previous first responder (this will trigger valueChangedTo delegate)
    UITextField *previousFirstResponder = self.currentlyEditingField;
    _currentlyEditingIndexPath = currentlyEditing;
    if (!currentlyEditing) {
        [previousFirstResponder resignFirstResponder];
    }

    if (!_currentlyEditingIndexPath) {
        return;
    }

    // update first responder
    if (self.programmaticallyTransitioningCurrentEdit) {
        NSArray *visibleRows = self.tableView.indexPathsForVisibleRows;
        if ([visibleRows containsObject:self.currentlyEditingIndexPath]) {
            self.programmaticallyTransitioningCurrentEdit = NO;
            [self makeCurrentlyEditingFieldFirstResponder];
        }
        [self scrollToCurrentlyEditingIndexPath];
    } else if (previousFirstResponder) {
        [self scrollToCurrentlyEditingIndexPath];
    }
}

- (UITextField *)currentlyEditingField {
    if (!self.currentlyEditingIndexPath) {
        return nil;
    } else {
        UITextField *field = self.textFields[self.currentlyEditingIndexPath.fod_indexPathKey];
        return field;
    }
}

- (void) makeCurrentlyEditingFieldFirstResponder {
    UITextField *field = self.currentlyEditingField;
    if (!field || field.isFirstResponder) {
        return;
    }
    if (![field becomeFirstResponder]) {
        NSLog(@"becomeFirstResponder failed");
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.programmaticallyTransitioningCurrentEdit) {
        [self resignFirstResponderIfNotVisible];
    }
}

- (void) resignFirstResponderIfNotVisible {
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:self.currentlyEditingIndexPath];
    cellRect = [self.tableView convertRect:cellRect toView:self.tableView.superview];
    CGRect visibleTableViewFrame = UIEdgeInsetsInsetRect(self.tableView.frame, self.tableView.contentInset);

    BOOL partiallyVisible = CGRectContainsRect(visibleTableViewFrame, cellRect) || CGRectIntersectsRect(visibleTableViewFrame, cellRect);

    if (!partiallyVisible && !self.keyboardIsComingUp) {
        self.currentlyEditingIndexPath = nil;
    }
}

- (void) moveToNextField:(id)sender {
    if (self.programmaticallyTransitioningCurrentEdit) {
        return;
    }
    self.programmaticallyTransitioningCurrentEdit = YES;
    BOOL isEditable=NO;
    NSIndexPath *idx = self.currentlyEditingIndexPath;
    NSIndexPath *startIdx = idx;
    if (!idx) {
        idx = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    do {
        // bump indexPath
        idx = [NSIndexPath indexPathForRow:idx.row+1 inSection:idx.section];
        if (idx.row >= [self tableView:self.tableView numberOfRowsInSection:idx.section]) {
            idx = [NSIndexPath indexPathForRow:0 inSection:idx.section+1];
            if (idx.section >= [self numberOfSectionsInTableView:self.tableView]) {
                idx = [NSIndexPath indexPathForRow:0 inSection:0];
            }
        }
        if ([idx isEqual:startIdx]) {
            // wrapped
            self.programmaticallyTransitioningCurrentEdit = NO;
            return;
        }

        isEditable = [self isEditableAtIndexPath:idx];
    } while (!isEditable);

    self.currentlyEditingIndexPath = idx;
}

- (void) moveToPrevField:(id)sender {
    if (self.programmaticallyTransitioningCurrentEdit) {
        return;
    }
    self.programmaticallyTransitioningCurrentEdit = YES;
    BOOL isEditable=NO;
    NSIndexPath *idx = self.currentlyEditingIndexPath;
    NSIndexPath *startIdx = idx;
    do {
        // bump indexPath
        idx = [NSIndexPath indexPathForRow:idx.row-1 inSection:idx.section];
        if (idx.row < 0) {
            if (idx.section == 0) {
                // wrap around backwards and move to last row of last section
                idx = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:self.tableView.numberOfSections-1]-1
                                         inSection:self.tableView.numberOfSections-1];
            } else {
                // move to last row of prev section
                idx = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:idx.section-1]-1 inSection:idx.section-1];
            }
        }
        if ([idx isEqual:startIdx]) {
            // wrapped
            self.programmaticallyTransitioningCurrentEdit = NO;
            return;
        }
        isEditable = [self isEditableAtIndexPath:idx];
    } while (!isEditable);
    self.currentlyEditingIndexPath = idx;
}

#pragma mark - form saving

- (void) savePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(validateForm:inForm:)]) {
        NSString *errorMessage = [self.delegate validateForm:self.model inForm:self];
        if (errorMessage) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:errorMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    [[self.view fod_findFirstResponder] resignFirstResponder];
    [self.model commitEdits];
    [self.delegate modelSaved:self.model
                     userInfo:self.userInfo];
}

- (void) cancelPressed:(id)sender {
    [self.model undoEdits];
    [self.delegate formCancelled:self.model
                        userInfo:self.userInfo];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        [self cancelPressed:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model[section] numberOfRows];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.model[section] title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FODFormRow *row = self.model[indexPath];
    FODFormCell *cell = [self.cellFactory cellForRow:row];
    [cell configureCellForRow:row
                 withDelegate:self];

    if ([cell isKindOfClass:[FODTextInputCell class]]) {
        FODTextInputCell *textCell = (FODTextInputCell*)cell;
        self.textFields[indexPath.fod_indexPathKey] = textCell.textField;
    } else {
        [self.textFields removeObjectForKey:indexPath.fod_indexPathKey];
    }

    return cell;
}

- (UIView*) textInputAccessoryView {
    return self.toolbar;
}

#pragma mark Keyboard Management

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* userInfo = [notification userInfo];

    CGRect keyboardFrame = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];

    self.keyboardIsComingUp = YES;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, keyboardFrame.size.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
    [self scrollToCurrentlyEditingIndexPath];
}

- (void)keyboardDidShow:(NSNotification*)note {
    self.keyboardIsComingUp = NO;
    //[self scrollToCurrentlyEditing];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary* userInfo = [notification userInfo];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentlyEditingIndexPath = nil;
    FODFormCell *cell = (FODFormCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [cell cellAction:self.navigationController];
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    FODFormRow *row = self.model[indexPath];
    return [row isKindOfClass:[FODDateSelectionRow class]] || [row isKindOfClass:[FODSelectionRow class]] || [row isKindOfClass:[FODFormModel class]];
}

#pragma mark form delegates

- (void)dateSelected:(NSDate *)date userInfo:(id)userInfo {
    self.currentlyEditingIndexPath = nil;
    FODFormRow *row = (FODFormRow*)userInfo;
    row.workingValue = date;
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark text input delegate

- (void) valueChangedTo:(NSString *)newValue
               userInfo:(id)userInfo {
    FODFormRow *row = (FODFormRow*)userInfo;
    row.workingValue = newValue;
}

- (void) startedEditing:(id)userInfo {
    FODFormRow *row = (FODFormRow*)userInfo;
    NSIndexPath *indexPath = row.indexPath;
    self.currentlyEditingIndexPath = indexPath;
}

#pragma mark switch delegate

- (void) switchValueChangedTo:(BOOL)newValue
                     userInfo:(id)userInfo {
    FODFormRow *row = (FODFormRow*)userInfo;
    row.workingValue = @(newValue);
    self.currentlyEditingIndexPath = nil;
    [self.tableView reloadData];
}

#pragma picker delegate

- (void) selectionMade:(NSArray*)selectedItems userInfo:(id)userInfo {
    FODFormRow *row = (FODFormRow*)userInfo;
    row.workingValue = selectedItems[0];
    if ([self.delegate respondsToSelector:@selector(pickerValueChanged:value:row:inForm:)]) {
        [self.delegate pickerValueChanged:row.key
                                    value:selectedItems[0]
                                      row:row
                                   inForm:self];
    }
    [self.tableView reloadData];
}

@end
