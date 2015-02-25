//
//  DetailArticleDataSource.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailArticleDataSource.h"
#import "DetailCommentTableViewCell.h"
@interface DetailArticleDataSource ()

@property(nonatomic, copy) NSString *cellIdentifier;
@property(nonatomic, copy) TableViewCellConfigureBlock aconfigureCellBlock;
@property(nonatomic, copy) TableViewCellConfigureBlock bconfigureCellBlock;
@end

@implementation DetailArticleDataSource

- (id)init {
  return [super init];
}

- (id)initWithItems:(NSDictionary *)anItem
               andArray:(NSArray *)items
         cellIdentifier:(NSString *)aCellIdentifier
    aconfigureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
    bconfigureCellBlock:(TableViewCellConfigureBlock)bConfigureCellBlock {
  self = [super init];
  if (self) {
    self.articleDic = anItem;
    self.commentsArray = items;
    self.cellIdentifier = aCellIdentifier;
    self.aconfigureCellBlock = [aConfigureCellBlock copy];
    self.bconfigureCellBlock = [bConfigureCellBlock copy];
  }
  return self;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if (0 == section) {
    return 1;
  } else {
    return self.commentsArray.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                        forIndexPath:indexPath];
    self.aconfigureCellBlock(cell, self.articleDic);
    return cell;
  } else {
    DetailCommentTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"detailCommentCell"
                                        forIndexPath:indexPath];
    [cell configureForCell:[self.commentsArray objectAtIndex:indexPath.row]];
    return cell;
  }
}
@end
