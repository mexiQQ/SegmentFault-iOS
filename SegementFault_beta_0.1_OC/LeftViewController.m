//
//  LeftViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/11/14.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import "LeftViewController.h"

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
    
    NSArray *userhelp = @[@"Ask Questions"];
    NSArray *sites = @[@"首页",@"iOS",@"Android"];
    NSArray *others = @[@"About",@"Login Out"];
    
    _cellContent = [[NSMutableArray alloc] init];
    [_cellContent addObject:userhelp];
    [_cellContent addObject:sites];
    [_cellContent addObject:others];
}


#pragma mark - UITableViewDelegae and UITableViewDataSource

//返回Section的数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//返回每个Section的cell数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (section == 0)
        {
            return 1;
        }
        else if (section == 1)
        {
            return 3;
        }
        else
        {
            return 2;
        }
}

//对每个cell的内容进行定制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * MenuCellIdentifier = @"MenuCell";
    MeunTableViewCell* cell = [_mytableview dequeueReusableCellWithIdentifier:MenuCellIdentifier];
    
    cell.menuTitle.text = [[_cellContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (cell == nil)
    {
        cell = [[MeunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:MenuCellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [[UIColor alloc] initWithRed:0/255.0f green:154/255.0f blue:97/255.0f alpha:0.3];
    return cell;
}

//指定每个Section的header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)
        return 80.0f;
    else
        return 30.0f;
}

//指定每个Section的header内容
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        LeftTableViewUserSectionView *header = [[[NSBundle mainBundle] loadNibNamed: @"MenuTableViewUserSection"
                                                                          owner: self
                                                                        options: nil] lastObject];
        header.userName.text = @"么西QQ";
        header.userAvator.image = [UIImage imageNamed:@"t_avator"];
        header.userResu.text = @"登录后定制感兴趣的内容";
        return header;
    }
    else if (section == 1)
    {
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

//指定点击每个Cell后执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    else if(indexPath.section==1)
    {
        UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"main"];
        
        //UINavigationController *nav = mainViewController.childViewControllers[0];
        //MainTableViewController *center = nav.viewControllers[0];
        
        switch (indexPath.row)
        {
            case 0:
            {
                //center.tagType =@"home";
                [self.mm_drawerController
                setCenterViewController:mainViewController
                withCloseAnimation:YES
                completion:nil];
                break;
            }
            case 1:{
                //center.tagType =@"ios";
                [self.mm_drawerController
                setCenterViewController:mainViewController
                withCloseAnimation:YES
                completion:nil];
                break;
            }
            case 2:{
                //center.tagType =@"android";
                [self.mm_drawerController
                setCenterViewController:mainViewController
                withCloseAnimation:YES
                completion:nil];
                break;
            }
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:
            {
                break;
            }
            case 1:{
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle:nil
                                              delegate:self
                                              cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"退出账号"
                                              otherButtonTitles:nil,nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
                [actionSheet showInView:self.view];
                break;
            }
        }
    }
}

//点击ActionSheet的操作
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSLog(@"hello");
    }else{
        NSLog(@"hi");
    }
}

-(void)changeMenu{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *addMenuController = [mainStoryboard instantiateViewControllerWithIdentifier:@"addMenu"];
    addMenuController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:addMenuController animated:YES completion:^{
        NSLog(@"hello world");
    }];
}

@end
