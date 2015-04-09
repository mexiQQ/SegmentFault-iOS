//
//  CommetnTableViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/21.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "CommetnTableViewController.h"
#import "CommentStore.h"
#import "CommentDataSource.h"
#import "DetailQuestionStore.h"
#import "DetailCommentTableViewCell.h"
#import "DetailWriteCommentTableViewCell.h"
#import "MarkdownEditorViewController.h"
#import "MXUtil.h"
@interface CommetnTableViewController ()
@property(nonatomic, strong) CommentDataSource *myCommentDataSource;
@property(nonatomic, strong) NSArray *comments;
@end

@implementation CommetnTableViewController
@synthesize id_ = _id_;

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupBar];
  [self setupTableView];
}

#pragma mark - table datasource
// 设置tableview
- (void)setupTableView {
  [self setupRefreshControl];
  [self firstInitData];
}

- (void)setupBar {
  // 设置 barTitle
  [self.titleButton setBackgroundImage:[UIImage imageNamed:@"comments_title"]
                              forState:UIControlStateNormal];

  self.messageComposerView = [[MessageComposerView alloc] init];
  self.messageComposerView.delegate = self;
  [self.tableView addSubview:self.messageComposerView];

  self.messageComposerView.messagePlaceholder = @"Type a comment...";
}

//第一次加载数据时自动弹出
- (void)firstInitData {
  [UIView animateWithDuration:0.25
      delay:0
      options:UIViewAnimationOptionBeginFromCurrentState
      animations:^(void) {
        self.tableView.contentOffset =
            CGPointMake(0, -self.refreshControl.frame.size.height - 20);
      }
      completion:^(BOOL finished) {
        [self.refreshControl beginRefreshing];
        [self.refreshControl
            sendActionsForControlEvents:UIControlEventValueChanged];
      }];
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
  [[CommentStore sharedStore] readNewData:^(NSMutableArray *array) {
    self.comments = array;
    self.myCommentDataSource = [[CommentDataSource alloc]
             initWithItems:array
            cellIdentifier:@"detailCommentCell"
        configureCellBlock:^(DetailCommentTableViewCell *cell,
                             NSMutableDictionary *item) {
          [cell configureForCell:item];
        }];
    self.tableView.dataSource = self.myCommentDataSource;
    [self.refreshControl endRefreshing];
  } id_:self.id_];
}

#pragma mark - table delegate

// 定义 cell 高度(定死)
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  DetailCommentTableViewCell *cell;
  if (!cell) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"detailCommentCell"];
  }
  [cell configureForCell:[self.comments objectAtIndex:indexPath.row]];
  [cell setNeedsLayout];
  [cell layoutIfNeeded];

  CGFloat height =
      [cell.contentView
          systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  height += 1;
  return height;
}

#pragma mark - MessageComposerViewDelegate
- (void)messageComposerSendMessageClickedWithMessage:(NSString *)message {
  NSLog(@"send click");
}

- (void)messageComposerUserTyping {
  NSLog(@"text changed");
}

- (void)messageComposerFrameDidChange:(CGRect)frame
                withAnimationDuration:(CGFloat)duration
                             andCurve:(NSInteger)curve {
  NSLog(@"frame changed");
}

//- (UIView *)tableView:(UITableView *)tableView
//    viewForFooterInSection:(NSInteger)section {
//  DetailWriteCommentTableViewCell *cell =
//      [tableView dequeueReusableCellWithIdentifier:@"detailWriteCommentCell"];
//
//  // 给 label 增加点击事件
//  UITapGestureRecognizer *tap =
//      [[UITapGestureRecognizer alloc] initWithTarget:self
//                                              action:@selector(wirteComment:)];
//  cell.wirteComment.userInteractionEnabled = YES;
//  [cell.wirteComment addGestureRecognizer:tap];
//  return cell;
//}

- (IBAction)wirteComment:(id)sender {
  UINavigationController *markdownNav =
      (UINavigationController *)[[MarkdownEditorViewController alloc] init];
  MarkdownEditorViewController *markdown = markdownNav.childViewControllers[0];
  [markdown setHandler:^(NSString *tagValue) {
    [self dismissViewControllerAnimated:YES completion:nil];
  } PullHandler:^(NSString *text) {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
      [[DetailQuestionStore sharedStore]
          commentAnswer:text
               answerId:self.id_
                 handle:^(NSDictionary *dic) {
                   NSString *status = [dic objectForKey:@"status"];
                   if (status.integerValue == 1) {
                     NSArray *a = [dic objectForKey:@"data"];
                     [[MXUtil sharedUtil]
                         showMessageScreen:[a[1] objectForKey:@"text"]];
                   } else {
                     [self dismissViewControllerAnimated:YES completion:nil];
                     [[MXUtil sharedUtil] showMessageScreen:@"提交成功"];
                     [self firstInitData];
                   }
                 }];
    } else {
      [[MXUtil sharedUtil] showMessageScreen:@"未登录"];
    }
  }];
  [self presentViewController:markdownNav animated:YES completion:nil];
}
@end
