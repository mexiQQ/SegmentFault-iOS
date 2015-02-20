//
//  DetailArticleTableViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailArticleTableViewController.h"
#import "DetailArticleStore.h"
#import "DetailArticleTableViewCell.h"
#import "DetailArticleDataSource.h"
#import "MessageStore.h"
#import "DetailCommentTableViewCell.h"
#import "UIButton+Bootstrap.h"
#import <ShareSDK/ShareSDK.h>
#import "MXUtil.h"

@interface DetailArticleTableViewController ()
@property (nonatomic, strong) DetailArticleDataSource   *myDetailArticleDataSource;
@property (nonatomic,strong) NSDictionary *articleDic;
@property (nonatomic,strong) NSArray *commentsArray;
@end

@implementation DetailArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册由于刷新 webview 高度的观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableViewHeight:) name:@"refreshArticleHeight" object:nil];
    
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
                         self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
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
    [[DetailArticleStore sharedStore] readNewData:^(NSDictionary *detailArticle,NSDictionary *detailComment) {
        self.articleDic = [detailArticle objectForKey:@"data"];
        self.commentsArray = [[detailComment objectForKey:@"data"] objectForKey:@"comment"];
        self.myDetailArticleDataSource = [[DetailArticleDataSource alloc] initWithItems:self.articleDic andArray:self.commentsArray cellIdentifier:@"detailArticleCell" aconfigureCellBlock:^(id cell, id item) {
            [cell configureForCell:item];
        } bconfigureCellBlock:^(id cell, id item) {
            [cell configureForCell:item];
        }];
        [self.refreshControl endRefreshing];
        self.tableView.dataSource = self.myDetailArticleDataSource;
    }];
}

- (void)setupTableView{
    [self setupRefreshControl];
    [self firstInitData];
}

#pragma mark - table delegate

// 计算高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(0==indexPath.section){
        NSNumber *a =(NSNumber *)[DetailArticleStore sharedStore].articleHeight;
        if(a == nil){
            return 80.01;
        }else{
            return a.floatValue;
        }
    }
    static  DetailCommentTableViewCell *cell;
    if(!cell){
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailCommentCell"];
    }
    
    [cell configureForCell:[self.commentsArray objectAtIndex:indexPath.row]];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    height += 1;
    return height;
}

// 计算 footView 高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(!self.articleDic){
        return 0;
    }else{
        if(section == 0){
            return 50;
        }else{
            return 0;
        }
    }
}

// 配置首尾 footView 内容
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(!self.articleDic){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }else{
        if(section == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
            [label setFont:[UIFont boldSystemFontOfSize:20]];
            label.text = @"2条评论";
            
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
        }else{
            return nil;
        }
    }
}


// 重新加载webView的高度
- (void)refreshTableViewHeight:(NSNotification *)notification{
    [self.tableView reloadData];
}

// 点击右上角更多操作
- (IBAction)moreAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"分享",@"收藏",@"举报",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

//点击 ActionSheet 的不同操作
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //分享
        NSString *url = [NSString stringWithFormat:@"http://segmentfault.com%@",[[self articleDic] objectForKey:@"editUrl"]];
        NSRange range = NSMakeRange (0, url.length-5);
        url = [url substringWithRange:range];
        
        NSString *shareContent = [NSString stringWithFormat:@"【%@】分享自 @SegmentFault，文章传送门：%@",[[self articleDic] objectForKey:@"title"],url];
        
        UIImage *image = [UIImage imageNamed:@"sf.png"];
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:shareContent
                                           defaultContent:[[self articleDic] objectForKey:@"title"]
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
        // 收藏
    }else if(buttonIndex == 2){
        // 举报
    }else{
        // 取消
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
