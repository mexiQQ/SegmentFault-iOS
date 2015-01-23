//
//  DetailArticleTableViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailArticleTableViewController.h"
#import "DetailArticleStore.h"
#import "DetailArticleTableViewCell.h"
#import "DetailArticleDataSource.h"
@interface DetailArticleTableViewController ()
@property (nonatomic, strong) DetailArticleDataSource   *myDetailArticleDataSource;
@property (nonatomic,strong) NSDictionary *articleDic;
@end

@implementation DetailArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

#pragma mark - table datasource

//第一次加载数据
- (void)firstInitData{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height-15);
                     } completion:^(BOOL finished){
                         [self.refreshControl beginRefreshing];
                         [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
                     }];
}

//设置下拉刷新进度条
- (void) setupRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)getLatestLoans{
    [[DetailArticleStore sharedStore] readNewData:^(NSDictionary *dic) {
        self.articleDic = dic;
        self.myDetailArticleDataSource = [[DetailArticleDataSource alloc] initWithItems:dic cellIdentifier:@"detailArticleCell" configureCellBlock:^(DetailArticleTableViewCell *cell, NSDictionary *item) {
            [cell configureForCell:item];
        }];
        [self.refreshControl endRefreshing];
        self.tableView.dataSource = self.myDetailArticleDataSource;
    }];

}

- (void)setupTableView{
    [self setupRefreshControl];
    [self firstInitData];
}

#pragma mark - table delegate

// 计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailArticleCell"];
    [cell configureForCell:self.articleDic];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"height is %f",height);
    
    height += 1;
    return height;
}


- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
