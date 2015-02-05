//
//  DetailQuestionTableViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailQuestionTableViewController.h"
#import "DetailQuestionDataSource.h"
#import "DetailQuestionStore.h"
#import "DetailQuestionTableViewCell.h"
@interface DetailQuestionTableViewController ()
@property (nonatomic, strong) DetailQuestionDataSource   *myDetailQuestionDataSource;
@end

@implementation DetailQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置 tableview
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

// 设置 datasource 获取数据
- (void)getLatestLoans{
    [[DetailQuestionStore sharedStore] readNewData:^(NSDictionary *detailQuestion,NSDictionary *detailAnswer) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:detailQuestion,@"question",detailAnswer,@"answer",nil];
        self.myDetailQuestionDataSource = [[DetailQuestionDataSource alloc] initWithItems:dic cellIdentifier:@"detailQuestionCell" configureCellBlock:^(DetailQuestionTableViewCell *cell, NSDictionary *item) {
            [cell configureForCell:item];
        } configureSectionBlock:^(id cell, NSDictionary *item) {
            
        }];
        [self.refreshControl endRefreshing];
        self.tableView.dataSource = self.myDetailQuestionDataSource;
    }];
}

- (void)setupTableView{
    [self setupRefreshControl];
    [self firstInitData];
}

#pragma mark - table delegate

// 计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
