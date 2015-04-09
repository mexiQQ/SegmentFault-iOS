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

  messageLabel.text = @"Loading ...";
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

  self.messageComposerView = [[MessageComposerView alloc] init];
  self.messageComposerView.delegate = self;
  [self.myview addSubview:self.messageComposerView];

  self.messageComposerView.messagePlaceholder = @"Type a comment...";
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

- (void)tapToHideKeyboard:(UITapGestureRecognizer *)tap {
  [self.view endEditing:YES];
}
@end
