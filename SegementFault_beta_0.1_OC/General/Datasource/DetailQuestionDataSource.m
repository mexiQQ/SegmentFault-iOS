//
//  DetailQuestionDataSource.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailQuestionDataSource.h"

@interface DetailQuestionDataSource()
@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) NSString *questionTitle;
@property (nonatomic, copy) NSArray *answers;
@property (nonatomic, copy) TableViewCellConfigureBlock aconfigureCellBlock;
@property (nonatomic, copy) TableViewCellConfigureBlock bconfigureCellBlock;

@end

@implementation DetailQuestionDataSource
- (id)init
{
    return [super init];
}

- (id)initWithItems:(NSDictionary *)anItem
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
configureSectionBlock:(TableViewCellConfigureBlock)bConfigureCellBlock
{
    self = [super init];
    if (self) {
        self.item = anItem;
        self.cellIdentifier = aCellIdentifier;
        self.aconfigureCellBlock = [aConfigureCellBlock copy];
        self.bconfigureCellBlock = [bConfigureCellBlock copy];
        self.questionTitle = [[[self.item objectForKey:@"question"] objectForKey:@"data"] objectForKey:@"title"];
        self.answers = [[[self.item objectForKey:@"answer"] objectForKey:@"data"] objectForKey:@"available"];
    }
    return self;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                                            forIndexPath:indexPath];
    self.aconfigureCellBlock(cell, self.item);
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(0 == section){
        return self.questionTitle;
    }
    return nil;
}

// 从这开始修改
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section != 0){
        UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.cellIdentifier];
        self.bconfigureCellBlock(cell, self.item);
        return cell;
    }
    return nil;
}

@end
