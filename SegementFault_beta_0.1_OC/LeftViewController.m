//
//  LeftViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/11/14.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import "LeftViewController.h"
#import "MXUtil.h"
@interface LeftViewController ()
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"bg"];
    self.view.layer.contents = (id) image.CGImage;
    
    _mytableview.delegate = self;
    _mytableview.dataSource = self;
    [_mytableview setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTags:) name:@"TagsChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginSuccess" object:nil];
    
    // 初始化侧边栏菜单
    NSArray *userhelp = @[@"Ask Messages"];
    
    NSMutableArray *sites = [[TagStore sharedStore] getCurrentTags];
    [sites insertObject:@"Home" atIndex:0];
    
    NSString *temp = @"Login";
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"user"])
    {
        temp = @"Login Out";
    }
    NSArray *a = @[@"About",temp];
    NSMutableArray *others = [[NSMutableArray alloc] initWithArray:a];
    
    _cellContent = [[NSMutableArray alloc] init];
    [_cellContent addObject:userhelp];
    [_cellContent addObject:sites];
    [_cellContent addObject:others];
    
    [self getMessagesNumberAndUpdateBarNumber];
}


#pragma mark - UITableViewDataSource

// 返回 Section 的数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

// 返回每个 Section 的 cell 数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return ((NSArray *)[_cellContent objectAtIndex:0]).count;
    }else if (section == 1){
        return ((NSArray *)[_cellContent objectAtIndex:1]).count;
    }else{
        return ((NSArray *)[_cellContent objectAtIndex:2]).count;
    }
}

// 对每个 cell 的内容进行定制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * MenuCellIdentifier = @"MenuCell";
    MeunTableViewCell* cell = [_mytableview dequeueReusableCellWithIdentifier:MenuCellIdentifier];
    if (cell == nil){
        cell = [[MeunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:MenuCellIdentifier];
    }
    
    // 设置 cell 标题和图标
    NSString *title = [[_cellContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.menuTitle.text = title;
    cell.menuImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",title]];
    
    //设置 cell 背景色和view
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    
    // 设置选中 cell 的颜色
    cell.selectedBackgroundView.backgroundColor = [[UIColor alloc] initWithRed:0/255.0f green:154/255.0f blue:97/255.0f alpha:0.3];
    return cell;
}

#pragma mark - UITableViewDelegate

// 指定每个 Section 的 header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0)
        return 80.0f;
    else
        return 30.0f;
}

// 指定每个 Section 的 header 内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0){
        LeftTableViewUserSectionView *header = [[[NSBundle mainBundle] loadNibNamed: @"MenuTableViewUserSection"
                                                                          owner: self
                                                                        options: nil] lastObject];
        NSDictionary *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
        if(user){
            // 使用 GCD 异步获取用户头像
            __block NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://sfault-avatar.b0.upaiyun.com%@",[user objectForKey:@"avatar"]]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    header.userAvator.image = [UIImage imageWithData:data];
                });
            });
            header.userName.text = [user objectForKey:@"name"];
            header.userResu.text = [NSString stringWithFormat:@"%@ 声望",[user objectForKey:@"rank"]];
        }else{
            header.userName.text = @"Anonymous";
            header.userAvator.image = [UIImage imageNamed:@"t_avator"];
            header.userResu.text = @"登录后定制感兴趣的内容";
        }
        return header;
    }else if (section == 1){
        LeftTableViewSectionView *header = [[[NSBundle mainBundle] loadNibNamed: @"MenuTableViewSectionView"
                                                        owner: self
                                                      options: nil] lastObject];
        header.sectionTitle.text = @"Tags";
        [header.addMenu addTarget:self action:@selector(changeMenu) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }else{
        LeftTableViewSectionView *header = [[[NSBundle mainBundle] loadNibNamed: @"MenuTableViewSectionView"
                                                                          owner: self
                                                                        options: nil] lastObject];
        header.sectionTitle.text = @"Others";
        [header.addMenu setTitle:@"" forState:UIControlStateNormal];
        return header;
    }
}

// 指定点击每个 Cell 后执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"messagePage"];
        [self.mm_drawerController setCenterViewController:mainViewController withCloseAnimation:YES completion:nil];
    }
    else if(indexPath.section==1){
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainPage"];
        [self.mm_drawerController setCenterViewController:mainViewController withCloseAnimation:YES completion:nil];
        [TagStore sharedStore].currentShowTag = [[_cellContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else{
        switch (indexPath.row){
            case 0:{
                UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"aboutPage"];
                [self.mm_drawerController setCenterViewController:mainViewController withCloseAnimation:YES completion:nil];
                break;
            }case 1:{
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"user"]){
                    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                                  initWithTitle:nil
                                                  delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:@"退出账号"
                                                  otherButtonTitles:nil,nil];
                    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                    [actionSheet showInView:self.view];
                    break;
                }else{
                    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *loginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"login"];
                    loginViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    [self presentViewController:loginViewController animated:YES completion:nil];
                    break;
                }
            }
        }
    }
}

// 点击 ActionSheet 的操作
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
        [_cellContent[2] replaceObjectAtIndex:1 withObject:@"Login"];
        [_mytableview reloadData];
    }else{
        NSLog(@"取消");
    }
}

-(void)changeMenu{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *addMenuController = [mainStoryboard instantiateViewControllerWithIdentifier:@"addMenuPage"];
    addMenuController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:addMenuController animated:YES completion:nil];
}

- (void)updateTags:(NSNotification *)notification{
    NSMutableArray *temp = [[TagStore sharedStore] getCurrentTags];
    [temp insertObject:@"Home" atIndex:0];
    [_cellContent replaceObjectAtIndex:1 withObject:temp];
    [_mytableview reloadData];
}

- (void)loginSuccess:(NSNotification *)notification{
    NSLog(@"登录成功");
    [_cellContent[2] replaceObjectAtIndex:1 withObject:@"Login Out"];
    [_mytableview reloadData];
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
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/user/stat?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
        NSError *error = nil;
        NSLog(@"user token is %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
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
}

@end
