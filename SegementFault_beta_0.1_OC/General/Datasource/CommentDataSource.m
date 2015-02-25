//
//  CommentDataSource.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/21.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "CommentDataSource.h"

@implementation CommentDataSource

- (id)init {
  return [super init];
}

- (id)initWithItems:(NSArray *)anItems
        cellIdentifier:(NSString *)aCellIdentifier
    configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock {
  return [super initWithItems:anItems
               cellIdentifier:aCellIdentifier
           configureCellBlock:aConfigureCellBlock];
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  return [super itemAtIndexPath:indexPath];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [super tableView:tableView numberOfRowsInSection:(NSInteger)section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

@end
