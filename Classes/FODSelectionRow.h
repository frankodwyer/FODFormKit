//
//  FODSelectionRow.h
//  FormKitDemo
//
//  Created by Frank on 27/12/2013.
//  Copyright (c) 2013 Frank O'Dwyer. All rights reserved.
//  
//  Modified work Copyright 2014 Thimo Bess, arconsis IT-Solutions GmbH
//

#import "FODFormRow.h"
#import "FODFormSelectableRow.h"


@interface FODSelectionRow : FODFormSelectableRow

@property (nonatomic,strong) NSArray *items;

@end
