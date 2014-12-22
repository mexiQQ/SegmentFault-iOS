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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0&&indexPath.row==0){
        static NSString * MenuCellIdentifier = @"Cell";
        MeunTableViewCell* cell = [_mytableview dequeueReusableCellWithIdentifier:MenuCellIdentifier];
        cell.menuTitle.text = @"Ask Questions";
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [[UIColor alloc] initWithRed:0/255.0f green:154/255.0f blue:97/255.0f alpha:0.3];
        return cell;
    }else{
        static NSString * MenuCellIdentifier = @"Cell";
        MeunTableViewCell* cell = [_mytableview dequeueReusableCellWithIdentifier:MenuCellIdentifier];
        if (cell == nil)
        {
            cell = [[MeunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MenuCellIdentifier];
        }
        
        NSLog(@"indexPath.section:%d",indexPath.section -1);
        

        cell.menuTitle.text = [[_cellContent objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [[UIColor alloc] initWithRed:0/255.0f green:154/255.0f blue:97/255.0f alpha:0.3];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)
        return 80.0f;
    else
        return 30.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _mytableview)
    {
        if (section == 0)
        {
            return nil;
        }
        else if (section == 1)
        {
            return @"SITES";
        }
        else
        {
            return @"OTHER";
        }
    }
    else
    {
        return nil;
    }
}


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

-(void)changeMenu{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *addMenuController = [mainStoryboard instantiateViewControllerWithIdentifier:@"addMenu"];
    
    addMenuController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:addMenuController animated:YES completion:^{
        NSLog(@"hello world");
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return;
    }
    else if(indexPath.section==1)
    {
        switch (indexPath.row)
        {
            case 0:
            {

            }
                break;
                
            default:
                break;
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSLog(@"hello");
    }else{
        NSLog(@"hi");
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
