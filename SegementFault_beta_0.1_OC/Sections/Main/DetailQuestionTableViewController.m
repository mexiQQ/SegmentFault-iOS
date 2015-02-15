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
#import "DetailAnswerTableViewCell.h"
#import "UIButton+Bootstrap.h"
#import "MessageStore.h"

@interface DetailQuestionTableViewController ()
@property (nonatomic, strong) DetailQuestionDataSource   *myDetailQuestionDataSource;
@property (nonatomic, strong) NSDictionary *question;
@property (nonatomic, strong) NSArray *answers;
@end

@implementation DetailQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册用于刷新 webview 高度的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableViewHeight:) name:@"refreshQuestionHeight" object:nil];
    
    // 设置 tableview
    [self setupTableView];
}

#pragma mark - table datasource

// 设置下拉刷新进度条
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
    [[DetailQuestionStore sharedStore] readNewData:^(NSDictionary *detailQuestion,NSDictionary *detailAnswer)  {
        self.question = detailQuestion;
        self.answers = [[detailAnswer objectForKey:@"data"] objectForKey:@"available"];
        self.myDetailQuestionDataSource = [[DetailQuestionDataSource alloc] initWithItems:self.answers cellIdentifier:@"detailQuestionCell" configureCellBlock:^(DetailQuestionTableViewCell *cell, NSDictionary *item) {
            [cell configureForCell:item];
        }];
        [self.refreshControl endRefreshing];
        self.tableView.dataSource = self.myDetailQuestionDataSource;
    }];
}

// 第一次加载数据
- (void)firstInitData{
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^(void){
                         self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height-20);
                     } completion:^(BOOL finished){
                         [self.refreshControl beginRefreshing];
                         [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
                     }];
}


- (void)setupTableView{
    [self setupRefreshControl];
    [self firstInitData];
}

#pragma mark - table delegate

// 重新加载webView的高度
- (void)refreshTableViewHeight:(NSNotification *)notification{
    [self.tableView reloadData];
}

// 计算 cell 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

// 计算 headerView 高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(0 != section ){
        NSNumber *a =(NSNumber *)[[DetailQuestionStore sharedStore].answersHeights objectForKey:[NSString stringWithFormat:@"answer%ld",((long)section-1)]];
        if(a == nil){
            return 80.01;
        }else{
            return a.floatValue;
        }
    }else{
        NSNumber *b = [DetailQuestionStore sharedStore].questionHeight;
        if( nil == b || 0 == b){
            return 200.01;
        }else{
            return b.floatValue;
        }
    }
}

// 计算 footView 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(!self.question){
        return 0;
    }else{
        if(section == 0){
            return 50;
        }else if(section == self.answers.count){
            return 80;
        }else{
            return 0;
        }
    }
}

// 设置所有 cell 的 headerView
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(!self.question){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }else{
        if(section != 0){
            DetailAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailAnswerCell"];
            [cell configureForCell:self.answers[section - 1] index:(NSInteger *)(section - 1)];
            return cell;
        }else{
            DetailQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailQuestionCell"];
            [cell configureForCell:self.question];
            return cell;
        }
    }
}

// 配置首尾 footView 内容
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(!self.question){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }else{
        if(section == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
            [label setFont:[UIFont boldSystemFontOfSize:20]];
            label.text = @"2个回答";
            
            UIButton *a = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 140, 10, 60, 30)];
            [a setTitle:@"关注" forState:UIControlStateNormal];
            [a successStyle];
            
            UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 70, 10, 60, 30)];
            [b setTitle:@"收藏" forState:UIControlStateNormal];
            [b defaultStyle];
        
            [cell addSubview:a];
            [cell addSubview:b];
            [cell addSubview:label];
            return cell;
        }else if(section == self.answers.count){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 50)];
            [c setTitle:@"撰写答案" forState:UIControlStateNormal];
            [c successStyle];
            
            [cell addSubview:c];
            return cell;
        }else{
            return nil;
        }
    }
}

- (IBAction)backAction:(id)sender {
    if([MessageStore sharedStore].isMessages){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"readMessage" object:self userInfo:nil];
        [MessageStore sharedStore].isMessages = false;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
