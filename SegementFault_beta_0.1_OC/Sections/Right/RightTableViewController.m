//
//  RightTableViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/12.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "RightTableViewController.h"
#import "QuestionStore.h"
#import "DetailQuestionStore.h"
#import "ArticleStore.h"
#import "MessageStore.h"
#import "MessageDataSource.h"
#import "MessageTableViewCell.h"
#import "STHTTPRequest+JSON.h"
#import "MXUtil.h"
@interface RightTableViewController ()
@property (nonatomic,strong) NSArray *messages;
@property (nonatomic,strong) MessageDataSource *myMessageDataSource;
@end

@implementation RightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self getMessagesNumberAndUpdateBarNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table datasource
// 设置tableview
- (void)setupTableView{
    [self setupRefreshControl];
}


// 设置下拉刷新进度条
- (void) setupRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
}

// 设置距离上次刷新的时间
- (void)setRefreshTitle{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor grayColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
}

// 设置初始化和刷新的数据源
- (void)getLatestLoans{
    [self setRefreshTitle];
    [[MessageStore sharedStore] readNewData:^(NSArray *dic) {
        self.messages = dic;
        self.myMessageDataSource = [[MessageDataSource alloc] initWithItems:dic cellIdentifier:@"messageCell" configureCellBlock:^(MessageTableViewCell *cell, NSDictionary *item) {
            [cell configureForCell:item];
        }];
        self.tableView.dataSource = self.myMessageDataSource;
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - table delegate

// 设置点击选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 发出通知重新设置右边栏宽度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"readMessage" object:self userInfo:nil];
    
    // 设定问题文章详细页面为消息模式
    [MessageStore sharedStore].isMessages = true;
    
    // 抽取必要的参数信息，之后转到 model 层作处理
    NSDictionary *object = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"object"];
    NSString *type = [object objectForKey:@"type"];
    NSString *url = [[self.messages objectAtIndex:indexPath.row] objectForKey:@"url"];
    NSArray *id_ = [[MXUtil sharedUtil] rexMake:url rex:@"[0-9]+(?=\\?)"];
    
    if([type isEqualToString:@"question"]){
        // 清空上一个问题的所有高度信息
        [DetailQuestionStore sharedStore].answersHeights=nil;
        [DetailQuestionStore sharedStore].questionHeight=nil;

        [QuestionStore sharedStore].currentShowQuestionId = id_[0];
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *deatailQuestionController = [mainStoryboard instantiateViewControllerWithIdentifier:@"detailQuestionPage"];
        [self.navigationController pushViewController:deatailQuestionController animated:YES];
    }else if([type isEqualToString:@"article"]){
        [ArticleStore sharedStore].currentShowArticleId = id_[0];
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *deatailQuestionController = [mainStoryboard instantiateViewControllerWithIdentifier:@"detailArticlePage"];
        [self.navigationController pushViewController:deatailQuestionController animated:YES];
    }
}

// 定义 cell 高度(定死)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

#pragma mark - Messages Number

// 获取最新消息数并更新 UI
- (void) getMessagesNumberAndUpdateBarNumber{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimer *myTimer =  [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getMessageNumber:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    });
}

- (void)getMessageNumber:(NSNotification *)notification{
    NSLog(@"%@",[NSThread currentThread]);
    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/user/stat?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    NSError *error = nil;
    STHTTPRequest *r = [STHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [r startSynchronousWithError:&error];
    NSData *data = r.responseData;
    NSDictionary *message;
    if(data){
        message= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessagesNumber" object:self userInfo:message];
    });
}
@end
