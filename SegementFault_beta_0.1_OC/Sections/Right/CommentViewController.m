//
//  CommentViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/4/9.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentStore.h"
#import "CommentDataSource.h"
#import "DetailQuestionStore.h"
#import "DetailCommentTableViewCell.h"
#import "DetailWriteCommentTableViewCell.h"
#import "MarkdownEditorViewController.h"
#import "MXUtil.h"

@interface CommentViewController ()
@property(nonatomic, strong) CommentDataSource *myCommentDataSource;
@property(nonatomic, strong) NSArray *comments;
@property(nonatomic, retain) UIRefreshControl *refreshControl;
@end

@implementation CommentViewController
@synthesize mytableView = _mytableView;
@synthesize id_ = _id_;
@synthesize myview = _myview;
- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupBar];
  [self setupTableView];
  [self firstInitData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - table datasource
// 设置tableview
- (void)setupTableView {
  self.mytableView.delegate = self;
  self.mytableView.rowHeight = UITableViewAutomaticDimension;
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(tapToHideKeyboard:)];
  self.mytableView.userInteractionEnabled = YES;
  [self.mytableView addGestureRecognizer:tapGesture];
  self.mytableView.estimatedRowHeight = 60;

  UILabel *messageLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                               self.view.bounds.size.height)];

  messageLabel.text = @"加载中...";
  messageLabel.textColor = [UIColor grayColor];
  messageLabel.numberOfLines = 0;
  messageLabel.textAlignment = NSTextAlignmentCenter;
  messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
  [messageLabel sizeToFit];

  self.mytableView.backgroundView = messageLabel;
  self.mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupBar {
  [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
  [self.navigationController.navigationBar
      setBarTintColor:[UIColor colorWithRed:34 / 255.0
                                      green:72 / 255.0
                                       blue:57 / 255.0
                                      alpha:1.0]];

  self.messageComposerView = [[MessageComposerView alloc] init];
  self.messageComposerView.delegate = self;
  [self.myview addSubview:self.messageComposerView];

  self.messageComposerView.messagePlaceholder = @"写评论";
}

//第一次加载数据时自动弹出
- (void)firstInitData {
  [self getLatestLoans];
}

// 设置初始化和刷新的数据源
- (void)getLatestLoans {
  [[CommentStore sharedStore] readNewData:^(NSMutableArray *array) {

    self.mytableView.backgroundView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                 self.view.bounds.size.height)];
    self.comments = array;
    self.myCommentDataSource = [[CommentDataSource alloc]
             initWithItems:array
            cellIdentifier:@"detailCommentCell"
        configureCellBlock:^(DetailCommentTableViewCell *cell,
                             NSMutableDictionary *item) {
          [cell configureForCell:item];
        }];
    self.mytableView.dataSource = self.myCommentDataSource;
    [self.refreshControl endRefreshing];
  } id_:self.id_];
}

#pragma mark - table delegate

// 定义 cell 高度(定死)
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

#pragma mark - MessageComposerViewDelegate
- (void)messageComposerSendMessageClickedWithMessage:(NSString *)message {
  __weak typeof(self) weakself = self;
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
    [[DetailQuestionStore sharedStore]
        commentAnswer:message
             answerId:self.id_
               handle:^(NSDictionary *dic) {
                 NSString *status = [dic objectForKey:@"status"];
                 if (status.integerValue == 1) {
                   NSArray *a = [dic objectForKey:@"data"];
                   [[MXUtil sharedUtil]
                       showMessageScreen:[a[1] objectForKey:@"text"]];
                 } else {
                   [weakself.view endEditing:YES];
                   [[MXUtil sharedUtil] showMessageScreen:@"提交成功"];
                   [self firstInitData];
                 }
               }];
  } else {
    [[MXUtil sharedUtil] showMessageScreen:@"未登录"];
  }
}

- (void)tapToHideKeyboard:(UITapGestureRecognizer *)tap {
  [self.view endEditing:YES];
}
@end
