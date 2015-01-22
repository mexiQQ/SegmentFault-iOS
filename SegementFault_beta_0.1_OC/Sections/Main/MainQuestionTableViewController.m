//
//  MainQuestionTableTableViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "MainQuestionTableViewController.h"
static BOOL firstInit = true;

@interface MainQuestionTableViewController ()
@property (nonatomic) BOOL loadingMore;
@property (nonatomic) int page;
@property (nonatomic, strong) QuestionsDataSource *myQuestionDataSource;
@property (nonatomic, strong) NSMutableArray *questions;
@end

@implementation MainQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    firstInit = true;
    [self setupTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - table datasource
//设置tableview
- (void)setupTableView{
    [self setupRefreshControl];
    [self firstInitData];
}

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

//设置初始化和刷新的数据源
- (void)getLatestLoans{
    [self setRefreshTitle];
    QuestionStore *store = [QuestionStore sharedStore];
    [store readNewData:^(NSMutableArray *dic) {
        if(firstInit){
            self.questions = dic;
            self.myQuestionDataSource = [[QuestionsDataSource alloc] initWithItems:dic cellIdentifier:@"cell" configureCellBlock:^(QuestionTableViewCell *cell, NSMutableDictionary *item) {
                [cell configureForCell:item];
            }];
            self.tableView.dataSource = self.myQuestionDataSource;
            firstInit = false;
        }else{
            self.myQuestionDataSource.items = dic;
        }
        self.page = 1;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self createTableFooter];
    }];
}

//设置距离上次刷新的时间
- (void)setRefreshTitle{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor grayColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
}

#pragma mark - table More

//创建上拉加载更多
- (void) createTableFooter{
    self.tableView.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)];
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多信息"];
    [tableFooterView addSubview:loadMoreText];
    
    self.tableView.tableFooterView = tableFooterView;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    // 上拉到最底部时显示更多数据
    if(!_loadingMore && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height))){
        [self getPreLoansBegin];
    }
}

- (void)getPreLoansBegin{
    if (_loadingMore == NO){
        _loadingMore = YES;
        UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)];
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [tableFooterActivityIndicator startAnimating];
        [self.tableView.tableFooterView addSubview:tableFooterActivityIndicator];
        [self getPreLoans];
    }
}

- (void)getPreLoans{
    QuestionStore *store = [QuestionStore sharedStore];
    [store readOldData:^(NSMutableArray *dic) {
        self.questions = (NSMutableArray *)[self.questions arrayByAddingObjectsFromArray:dic];
        self.myQuestionDataSource.items = [self.myQuestionDataSource.items arrayByAddingObjectsFromArray:dic];
        self.loadingMore = NO;
        [self.tableView reloadData];
        [self createTableFooter];
    } page:++self.page];
}

#pragma mark - table delegate

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell configureForCell:[self.questions objectAtIndex:indexPath.row]];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];

    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1;
    return height;
}

- (IBAction)sliderLeft:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

- (IBAction)sliderRight:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}
@end
