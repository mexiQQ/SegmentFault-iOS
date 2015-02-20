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
#import <ShareSDK/ShareSDK.h>
#import "MXUtil.h"
#import "MessageStore.h"

@interface DetailQuestionTableViewController ()
@property (nonatomic, strong) DetailQuestionDataSource   *myDetailQuestionDataSource;
@property (nonatomic, strong) NSDictionary *question;
@property (nonatomic, strong) NSString *isFollowed;
@property (nonatomic, assign) NSInteger *answerNumber;
@property (nonatomic, strong) NSArray *availableAnswers;
@property (nonatomic, strong) NSDictionary *acceptAnswer;
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
        self.question = [detailQuestion objectForKey:@"data"];
        self.availableAnswers = [[detailAnswer objectForKey:@"data"] objectForKey:@"available"];
        self.acceptAnswer = [[detailAnswer objectForKey:@"data"] objectForKey:@"accepted"];
        if(self.acceptAnswer == [NSNull null]){
            self.answerNumber = (NSInteger *)(self.availableAnswers.count + 1);
        }else{
            self.answerNumber = (NSInteger *)(self.availableAnswers.count + 2);
        }
        self.myDetailQuestionDataSource = [[DetailQuestionDataSource alloc] initWithItems:self.answerNumber cellIdentifier:@"detailQuestionCell" configureCellBlock:nil];
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
                         self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
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
        }else if(section == ((int)self.answerNumber - 1)){
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
            if(self.acceptAnswer == [NSNull null]){
                DetailAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailAnswerCell"];
                [cell configureForCell:self.availableAnswers[section - 1] index:(NSInteger *)(section - 1) accepted:NO];
                return cell;
            }
            if(section == 1){
                DetailAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailAnswerCell"];
                [cell configureForCell:self.acceptAnswer index:(NSInteger *)(section - 1)
                              accepted:YES];
                return cell;
            }
            DetailAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailAnswerCell"];
            [cell configureForCell:self.availableAnswers[section - 2] index:(NSInteger *)(section - 1) accepted:NO];
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
            NSString *answersNumber = [self.question objectForKey:@"answers"];
            label.text = [NSString stringWithFormat:@"%@个回答",answersNumber];
            
            UIButton *a = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 140, 10, 60, 30)];
            
            self.isFollowed = [self.question objectForKey:@"isFollowed"];
            if(self.isFollowed.integerValue==1){
                [a setTitle:@"已关注" forState:UIControlStateNormal];
            }else{
                [a setTitle:@"关注" forState:UIControlStateNormal];
            }
            [a successStyle];
            [a addTarget:self action:@selector(attentionAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 70, 10, 60, 30)];
            [b setTitle:@"收藏" forState:UIControlStateNormal];
            [b defaultStyle];
            [b addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
        
            [cell addSubview:a];
            [cell addSubview:b];
            [cell addSubview:label];
            return cell;
        }else if(section == ((int)self.answerNumber - 1)){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            UIButton *c = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 50)];
            [c setTitle:@"撰写答案" forState:UIControlStateNormal];
            [c successStyle];
            //[c addTarget:self action:editAnswer forControlEvents:UIControlEventTouchDragInside];
            
            [cell addSubview:c];
            return cell;
        }else{
            return nil;
        }
    }
}

#pragma -mark moreAction
// 分享的更多操作
- (IBAction)moreAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"分享",@"举报",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

// 点击 ActionSheet 的不同操作
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //分享
        NSString *url = [NSString stringWithFormat:@"http://segmentfault.com%@",[self.question objectForKey:@"url"]];
        
        NSString *shareContent = [NSString stringWithFormat:@"【%@】分享自 @SegmentFault，问题传送门：%@",[self.question objectForKey:@"title"],url];
        
        UIImage *image = [UIImage imageNamed:@"sf.png"];
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:shareContent
                                           defaultContent:[self.question objectForKey:@"title"]
                                                    image:[ShareSDK pngImageWithImage:image]
                                                    title:@"SegmentFault"
                                                      url:url
                                              description:@"SegmentFault-iOS"
                                                mediaType:SSPublishContentMediaTypeNews];
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:actionSheet arrowDirect:UIPopoverArrowDirectionUp];
        
        //powerByHidden:这个参数是去掉授权界面Powered by ShareSDK的标志
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                                    scopes:nil
                                                             powerByHidden:YES
                                                            followAccounts:nil
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        //通过shareViewDelegate:参数修改分享界面的导航栏背景
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"内容分享"
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:nil
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:authOptions
                          shareOptions:shareOptions
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                        [[MXUtil sharedUtil] showMessageScreen:@"分享成功"];
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                        [[MXUtil sharedUtil] showMessageScreen:@"分享失败"];
                                    }
                                }];
    }else if(buttonIndex == 1){
        // 举报 （暂定未成功）
        [[MXUtil sharedUtil] showMessageScreen:@"未成功"];
    }else{
        // 取消
    }
}

// 返回上级菜单
- (IBAction)backAction:(id)sender {
    if([MessageStore sharedStore].isMessages){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"readMessage" object:self userInfo:nil];
        [MessageStore sharedStore].isMessages = false;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark footview IBActions

// 关注该问题
- (IBAction)attentionAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        if(self.isFollowed.integerValue == 0){
            [[DetailQuestionStore sharedStore] followQuestion:[self.question objectForKey:@"id"] handle:^(NSDictionary * dic) {
                NSLog(@"%@",dic);
                NSString * status = [dic objectForKey:@"status"];
                if(status.integerValue == 0){
                    [button setTitle:@"已关注" forState:UIControlStateNormal];
                    self.isFollowed = @"1";
                }
            }];
        }else{
            [[DetailQuestionStore sharedStore] unfollowQuestion:[self.question objectForKey:@"id"] handle:^(NSDictionary * dic) {
                NSLog(@"%@",dic);
                NSString * status = [dic objectForKey:@"status"];
                if(status.integerValue == 0){
                    [button setTitle:@"关注" forState:UIControlStateNormal];
                    self.isFollowed = @"0";
                }
            }];
        }
    }else{
        [[MXUtil sharedUtil] showMessageScreen:@"未登录"];
    }
}

// 收藏该问题
- (IBAction)collectAction:(id)sender{
    [[MXUtil sharedUtil] showMessageScreen:@"未成功"];
}

// 撰写答案
- (IBAction)editAnswer:(id)sender{
    //
}
@end
