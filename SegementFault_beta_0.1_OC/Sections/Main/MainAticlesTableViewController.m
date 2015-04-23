//
//  MainAticlesTableViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/12/23.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import "MainAticlesTableViewController.h"
#import "DetailArticleTableViewController.h"
#import "DetailArticleStore.h"
#import "RightTableViewController.h"
#import "MXUtil.h"
#import "SVProgressHUD.h"
static BOOL firstInit = true;

@interface MainAticlesTableViewController ()
@property(nonatomic) BOOL loadingMore;
@property(nonatomic) int page;
@property(nonatomic, strong) ArticlesDataSource *myArticleDataSource;
@property(nonatomic, strong) NSMutableArray *articles;
@end

@implementation MainAticlesTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  firstInit = true;

  [self setupBar];
  [self setupTableView];
  [self showWithStatus];

  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 120;
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
}

#pragma mark - table datasource
// 设置tableview
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
  ArticleStore *store = [ArticleStore sharedStore];
  [store readNewData:^(NSMutableArray *dic) {
    self.articles = dic;
    if (firstInit) {
      self.myArticleDataSource = [[ArticlesDataSource alloc]
               initWithItems:dic
              cellIdentifier:@"articleCell"
          configureCellBlock:^(ArticleTableViewCell *cell,
                               NSMutableDictionary *item) {
            [cell configureForCell:item];
          }];
      self.tableView.dataSource = self.myArticleDataSource;
      [self.tableView
          setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
      firstInit = false;
    } else {
      self.myArticleDataSource.items = dic;
      [self.tableView reloadData];
    }
    self.page = 1;
    [self.refreshControl endRefreshing];
    [self dismiss];
    [self createTableFooter];
  }];
}

#pragma mark - table More

// 创建上拉加载更多的地步View
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

// 获取更多数据
- (void)getPreLoans {
  ArticleStore *store = [ArticleStore sharedStore];
  [store readOldData:^(NSMutableArray *dic) {
    self.articles =
        (NSMutableArray *)[self.articles arrayByAddingObjectsFromArray:dic];
    self.myArticleDataSource.items =
        [self.myArticleDataSource.items arrayByAddingObjectsFromArray:dic];
    self.loadingMore = NO;
    [self.tableView reloadData];
    [self createTableFooter];
  } page:++self.page];
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

#pragma mark - table delegate

// 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

// 点击进入文章的详细页面
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // 清空 article 的高度信息
  [DetailArticleStore sharedStore].articleHeight = nil;

  // 执行跳转
  [ArticleStore sharedStore].currentShowArticleId =
      [[self.articles objectAtIndex:indexPath.row] objectForKey:@"id"];
  [self performSegueWithIdentifier:@"gotoArticleDetail" sender:self];
}

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
