//
//  MainQuestionTableTableViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "MainQuestionTableViewController.h"
#import "DetailQuestionStore.h"
#import "DetailQuestionTableViewController.h"
#import "RightTableViewController.h"
#import "SVProgressHUD.h"
#import <CoreText/CoreText.h>
#import "MXUtil.h"
static BOOL firstInit = true;

@interface MainQuestionTableViewController ()
@property(nonatomic) BOOL loadingMore;
@property(nonatomic) int page;
@property(nonatomic, strong) QuestionsDataSource *myQuestionDataSource;
@property(nonatomic, strong) NSMutableArray *questions;
@end

@implementation MainQuestionTableViewController
@synthesize titleButton = _titleButton;
- (void)viewDidLoad {
  [super viewDidLoad];
  firstInit = true;

  [self setupBar];
  [self setupTableView];
  [self showWithStatus];

  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 60;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
        (UIInterfaceOrientation)toInterfaceOrientation {
  return YES;
}

#pragma mark -
#pragma mark Show Methods

- (void)show {
  [SVProgressHUD show];
  [self getLatestLoans];
}

- (void)showWithStatus {
  [SVProgressHUD showWithStatus:@"加载中"];
  [self getLatestLoans];
}

#pragma mark -
#pragma mark Dismiss Methods Sample

- (void)dismiss {
  [SVProgressHUD dismiss];
}

- (void)dismissSuccess {
  [SVProgressHUD showSuccessWithStatus:@"Great Success!"];
}

- (void)dismissError {
  [SVProgressHUD showErrorWithStatus:@"Failed with Error"];
}

// 设置 bar
- (void)setupBar {
  // 设置 barTitle
  [self.titleButton
      setBackgroundImage:[UIImage imageNamed:@"NavigationBar_title"]
                forState:UIControlStateNormal];
  [self.navigationController.navigationBar
      setBarTintColor:[UIColor colorWithRed:34 / 255.0
                                      green:72 / 255.0
                                       blue:57 / 255.0
                                      alpha:1.0]];
}

#pragma mark - table datasource
//设置tableview
- (void)setupTableView {
  [self setupRefreshControl];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

// 设置下拉刷新进度条
- (void)setupRefreshControl {
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.backgroundColor = [UIColor whiteColor];
  self.refreshControl.tintColor = [UIColor grayColor];
  [self.refreshControl addTarget:self
                          action:@selector(getLatestLoans)
                forControlEvents:UIControlEventValueChanged];
}

// 设置初始化和刷新的数据源
- (void)getLatestLoans {
  [self setRefreshTitle];
  QuestionStore *store = [QuestionStore sharedStore];
  [store readNewData:^(NSMutableArray *dic) {
    if (firstInit) {
      self.questions = dic;
      self.myQuestionDataSource = [[QuestionsDataSource alloc]
               initWithItems:dic
              cellIdentifier:@"cell"
          configureCellBlock:^(QuestionTableViewCell *cell,
                               NSMutableDictionary *item) {
            [cell configureForCell:item];
          }];
      self.tableView.dataSource = self.myQuestionDataSource;
      [self.tableView
          setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
      firstInit = false;
    } else {
      self.myQuestionDataSource.items = dic;
      [self.tableView reloadData];
    }
    self.page = 1;
    [self.refreshControl endRefreshing];
    [self dismiss];
    [self createTableFooter];
  }];
}

// 设置距离上次刷新的时间
- (void)setRefreshTitle {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MMM d, h:mm a"];
  NSString *title =
      [NSString stringWithFormat:@"Last update: %@",
                                 [formatter stringFromDate:[NSDate date]]];
  NSDictionary *attrsDictionary =
      [NSDictionary dictionaryWithObject:[UIColor grayColor]
                                  forKey:NSForegroundColorAttributeName];
  NSAttributedString *attributedTitle =
      [[NSAttributedString alloc] initWithString:title
                                      attributes:attrsDictionary];
  self.refreshControl.attributedTitle = attributedTitle;
}

#pragma mark - table More

// 创建上拉加载更多的底部view
- (void)createTableFooter {
  self.tableView.tableFooterView = nil;
  UIView *tableFooterView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width,
                               40.0f)];
  UILabel *loadMoreText =
      [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
  [loadMoreText setCenter:tableFooterView.center];
  [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
  [loadMoreText setText:@"上拉显示更多信息"];
  [tableFooterView addSubview:loadMoreText];

  self.tableView.tableFooterView = tableFooterView;
}

// 上拉到最底部时显示更多数据
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  if (!_loadingMore &&
      scrollView.contentOffset.y >
          ((scrollView.contentSize.height - scrollView.frame.size.height))) {
    [self getPreLoansBegin];
  }
}

// 设置旋转进度条
- (void)getPreLoansBegin {
  if (_loadingMore == NO) {
    _loadingMore = YES;
    UIActivityIndicatorView *tableFooterActivityIndicator =
        [[UIActivityIndicatorView alloc]
            initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)];
    [tableFooterActivityIndicator
        setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [tableFooterActivityIndicator startAnimating];
    [self.tableView.tableFooterView addSubview:tableFooterActivityIndicator];
    [self getPreLoans];
  }
}

// 请求更多数据
- (void)getPreLoans {
  QuestionStore *store = [QuestionStore sharedStore];
  [store readOldData:^(NSMutableArray *dic) {
    self.questions =
        (NSMutableArray *)[self.questions arrayByAddingObjectsFromArray:dic];
    self.myQuestionDataSource.items =
        [self.myQuestionDataSource.items arrayByAddingObjectsFromArray:dic];
    self.loadingMore = NO;
    [self.tableView reloadData];
    [self createTableFooter];
  } page:++self.page];
}

#pragma mark - table delegate

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

// 点击进入文章的详细页面
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // 清空上一个问题的所有高度信息
  [DetailQuestionStore sharedStore].answersHeights = nil;
  [DetailQuestionStore sharedStore].questionHeight = nil;

  // 设置选中的问题id
  [QuestionStore sharedStore].currentShowQuestionId =
      [[self.questions objectAtIndex:indexPath.row] objectForKey:@"id"];

  // 跳转
  [self performSegueWithIdentifier:@"gotoQuestionDetail" sender:self];
}

// 点击弹出左边汉堡菜单
- (IBAction)sliderLeft:(id)sender {
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft
                                    animated:YES
                                  completion:nil];
}

- (IBAction)titleButtonAction:(id)sender {
  [self.tableView
      scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
            atScrollPosition:UITableViewScrollPositionTop
                    animated:NO];
}
@end
