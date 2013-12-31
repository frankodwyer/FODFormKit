//
//  FODPickerViewController.m
//
//  Created by Frank on 30/09/2012.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//

#import "FODPickerViewController.h"

@interface FODPickerViewController ()
@property (nonatomic) NSMutableSet *selectedItemsSet;
@end


@implementation FODPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.multipleSelection) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    }
}

- (NSMutableSet*) selectedItemsSet {
    if (!_selectedItemsSet) {
        _selectedItemsSet = [NSMutableSet setWithArray:self.initialSelection];
    }
    return _selectedItemsSet;
}

- (void) donePressed:(id)sender {
    [self.delegate selectionMade:self.selectedItemsSet.allObjects userInfo:self.userInfo];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = self.items[indexPath.row];

    if ([self.selectedItemsSet containsObject:self.items[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (!self.multipleSelection) {
        self.selectedItemsSet = [NSMutableSet setWithObject:self.items[indexPath.row]];
        [self donePressed:self];
    } else {
        if ([self.selectedItemsSet containsObject:self.items[indexPath.row]]) {
            [self.selectedItemsSet removeObject:self.items[indexPath.row]];
        } else {
            [self.selectedItemsSet addObject:self.items[indexPath.row]];
        }
    }
    [self.tableView reloadData];
}

@end
