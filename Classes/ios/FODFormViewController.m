//
//  FODFormViewController
//
//  Created by Frank on 29/09/2012.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//


#import "FODFormViewController.h"

#import "FODForm.h"
#import "FODDateSelectionRow.h"
#import "FODSelectionRow.h"
#import "FODTextInputRow.h"

#import "FODTextInputCell.h"
#import "FODSwitchCell.h"
#import "FODDatePickerViewController.h"
#import "FODPickerCell.h"
#import "FODDatePickerCell.h"

@interface FODFormViewController ()

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *prevButton; // previous button on toolbar
@property (nonatomic, strong) UIBarButtonItem *nextButton; // next button on toolbar
@property (nonatomic, strong) NSIndexPath *currentlyEditingIndexPath;
@property (nonatomic) BOOL programmaticallyTransitioningCurrentEdit;
@property (nonatomic, readonly) UITextField *currentlyEditingField;
@property (nonatomic, strong) NSMutableDictionary *textFields;
@property (nonatomic, strong) NSMutableDictionary *rowHeights;
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
@property (nonatomic) CGFloat keyboardHeight;

@end


@implementation FODFormViewController

- (id)initWithForm:(FODForm*)form
           userInfo:(id)userInfo
{
    self = [super init];
    if (self) {
        _form = form;
        _userInfo = userInfo;
        _rowHeights = [NSMutableDictionary dictionary];
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
    self.rowHeights = [[NSMutableDictionary alloc] init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"Button label")
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(savePressed:)];

    if (!self.form.parentForm) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:NSLocalizedString(@"Cancel", @"Button label")
                                                 style:UIBarButtonItemStyleBordered
                                                 target:self
                                                 action:@selector(cancelPressed:)];
    }

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.cellFactory = [[FODCellFactory alloc] initWithTableView:self.tableView
                                           andFormViewController:self];
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

- (void)setForm:(FODForm *)form {
    if (_form != form) {
        _form = form;
        [self.tableView reloadData];
        [self checkDependencies];
    }
}

#pragma mark handle moving from one text field to another

- (BOOL) isEditableAtIndexPath:(NSIndexPath*)indexPath {
    FODFormRow *row = self.form[indexPath];
    return [row isEditable];
}

- (void) scrollToIndexPath:(NSIndexPath*)indexPath {
    [UIView animateWithDuration:0.1 animations:^{
        [self.tableView scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:NO];
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.programmaticallyTransitioningCurrentEdit) {
                [self makeCurrentlyEditingFieldFirstResponder];
                self.programmaticallyTransitioningCurrentEdit = NO;
            }
        }
    }];
}

- (void) scrollToCurrentlyEditingIndexPath {
    if (self.currentlyEditingIndexPath) {
        [self scrollToIndexPath:self.currentlyEditingIndexPath];
    }
}

- (void)setCurrentlyEditingIndexPath:(NSIndexPath *)currentlyEditing {
    // do nothing if we're already editing this field
    if (_currentlyEditingIndexPath == currentlyEditing) {
        return;
    }

    // update ivar and *afterwards* resign the previous first responder (this will trigger valueChangedTo delegate)
    UITextField *previousFirstResponder = self.currentlyEditingField;
    _currentlyEditingIndexPath = currentlyEditing;
    if (!_currentlyEditingIndexPath) {
        [previousFirstResponder resignFirstResponder];
        return;
    }

    // update scroll position
    [self scrollToCurrentlyEditingIndexPath]; // end of scroll animation will update first responder if necessary
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
    if (!self.currentlyEditingIndexPath) {
        return;
    }
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
    if ([self.delegate respondsToSelector:@selector(validateForm:inFormViewController:)]) {
        id result = [self.delegate validateForm:self.form inFormViewController:self];
        if ([result isKindOfClass:[NSString class]]) { // if the validator returns a simple string, display it as an error message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", @"Alert title")
                                                            message:result
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK Button")
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        } else if ([result isEqualToNumber:@NO]) {
            return; // if the validator returns a boolean @NO then the form is invalid, and the validator handled UI.
        }
    }
    [[self.view fod_findFirstResponder] resignFirstResponder];
    [self.form commitEdits];
    [self.delegate formSaved:self.form
                    userInfo:self.userInfo];
}

- (void) cancelPressed:(id)sender {
    [self.form undoEdits];
    [self.delegate formCancelled:self.form
                        userInfo:self.userInfo];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (!parent) {
        [self cancelPressed:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.form.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.form[section] numberOfRows];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.form[section] title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FODFormRow *row = self.form[indexPath];
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

- (void)keyboardHeightChangedWithUserInfo:(NSDictionary*)userInfo {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, self.keyboardHeight, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
    [self scrollToCurrentlyEditingIndexPath];
}

- (void)keyboardWillShow:(NSNotification*)notification {

    NSDictionary* userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    self.keyboardIsComingUp = YES;

    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation)) {
        self.keyboardHeight = keyboardFrame.size.width;
    } else {
        self.keyboardHeight = keyboardFrame.size.height;
    }

    [self keyboardHeightChangedWithUserInfo:userInfo];
}

- (void)keyboardDidShow:(NSNotification*)note {
    self.keyboardIsComingUp = NO;
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary* userInfo = [notification userInfo];
    self.keyboardHeight = 0;
    [self keyboardHeightChangedWithUserInfo:userInfo];
}

- (void)checkDependencies
{
    NSArray *visible = [self.form.visibleSections copy];
    NSMutableArray *insertIndexPaths = [NSMutableArray new];
    NSMutableArray *deleteIndexPaths = [NSMutableArray new];
    NSMutableArray *insertSections = [NSMutableArray new];
    NSMutableArray *deleteSections = [NSMutableArray new];
    NSDictionary *values = [self.form extractValues];

    NSInteger section = 0;
    NSInteger row = 0;
    for (FODFormSection *formSection in self.form.sections) {
        row = 0;
        for (FODFormRow *formRow in formSection.rows) {
            if (formRow.dependency) {
                BOOL showRow = NO;
                BOOL needsReload = NO;

                for (NSString *key in formRow.dependency) {
                    NSArray *allowedValues = formRow.dependency[key];
                    id value = values[key];
                    if ([allowedValues containsObject:value]) {
                        showRow = YES;
                    }
                }

                if (formRow.hidden == showRow) {
                    if (showRow) {
                        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                    } else {
                        [deleteIndexPaths addObject:formRow.indexPath];
                    }
                }

                formRow.hidden = !showRow;
//                if (!showRow) {
//                    NSNumber *newHeight = @0;
//                    needsReload = ![self.rowHeights[row.indexPath.fod_indexPathKey] isEqual:newHeight];
//                    self.rowHeights[row.indexPath.fod_indexPathKey] = newHeight;
//                } else {
//                    needsReload = self.rowHeights[row.indexPath.fod_indexPathKey] != nil;
//                    [self.rowHeights removeObjectForKey:row.indexPath.fod_indexPathKey];
//                }

//                if (needsReload) {
//                    [reloadIndexPaths addObject:row.indexPath];
//                }
            }

            formRow.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            if (!formRow.hidden) {
                row++;
            }
        }

        BOOL showSection = formSection.numberOfRows > 0;

        if (showSection && formSection.dependency) {
            showSection = NO;
            for (NSString *key in formSection.dependency) {
                NSArray *allowedValues = formSection.dependency[key];
                id value = values[key];
                if ([allowedValues containsObject:value]) {
                    showSection = YES;
                }
            }

        }


        if (formSection.hidden == showSection) {
            if (showSection) {
                [insertSections addObject:@(section)];
            } else {
                [deleteSections addObject:@([visible indexOfObject:formSection])];
            }
        }
        formSection.hidden = !showSection;

        if (!formSection.hidden) {
            section++;
        }
    }
    [self.tableView beginUpdates];
    if (insertIndexPaths.count > 0) {
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }

    if (deleteIndexPaths.count > 0) {
        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }

    for (NSNumber *insertSection in insertSections) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:[insertSection unsignedIntegerValue]]
                      withRowAnimation:UITableViewRowAnimationFade];
    }

    for (NSNumber *deleteSection in deleteSections) {
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:[deleteSection unsignedIntegerValue]]
                      withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rowHeights[indexPath.fod_indexPathKey]) {
        return [self.rowHeights[indexPath.fod_indexPathKey] floatValue];
    } else {
        if ([[self.form[indexPath] class] respondsToSelector:@selector(defaultHeight)]) {
            return [[self.form[indexPath] class] defaultHeight];
        }

        return  tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentlyEditingIndexPath = nil;
    FODFormCell *cell = (FODFormCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [cell cellAction:self.navigationController];
}

- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    FODFormRow *row = self.form[indexPath];
    return [row isKindOfClass:[FODFormSelectableRow class]];
}

#pragma mark form delegates

- (void)adjustHeight:(CGFloat)newHeight forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([self tableView:self.tableView heightForRowAtIndexPath:indexPath] == newHeight) {
        return;
    }
    self.rowHeights[indexPath.fod_indexPathKey] = @(newHeight);
    [self.tableView reloadData];
}

- (void)adjustHeight:(CGFloat)newHeight animated:(BOOL)animated forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!animated) {
        [self adjustHeight:newHeight forRowAtIndexPath:indexPath];
    } else {
        if ([self tableView:self.tableView heightForRowAtIndexPath:indexPath] == newHeight) {
            return;
        }
        self.rowHeights[indexPath.fod_indexPathKey] = @(newHeight);
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self scrollToIndexPath:indexPath];
    }
}

- (void)dateSelected:(NSDate *)date userInfo:(id)userInfo {
    self.currentlyEditingIndexPath = nil;
    FODFormRow *row = (FODFormRow*)userInfo;
    row.workingValue = date;
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    [self checkDependencies];
}

#pragma mark text input delegate

- (void) valueChangedTo:(NSString *)newValue
               userInfo:(id)userInfo {
    FODFormRow *row = (FODFormRow*)userInfo;
    row.workingValue = newValue;
    [self checkDependencies];
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
    [self checkDependencies];
}

#pragma mark picker delegate

- (void) selectionMade:(NSArray*)selectedItems userInfo:(id)userInfo {
    FODFormRow *row = (FODFormRow*)userInfo;
    row.workingValue = selectedItems[0];
    if ([self.delegate respondsToSelector:@selector(pickerValueChanged:selectedItems:row:inFormViewController:)]) {
        [self.delegate pickerValueChanged:row.key
                            selectedItems:selectedItems
                                      row:row
                     inFormViewController:self];
    }
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    [self checkDependencies];
}


#pragma mark - image picker delegate -
- (void)imageSelected:(UIImage *)image withUserInfo:(id)userinfo
{
    FODFormRow *row = (FODFormRow *)userinfo;
    row.workingValue = UIImagePNGRepresentation(image);
}

@end
