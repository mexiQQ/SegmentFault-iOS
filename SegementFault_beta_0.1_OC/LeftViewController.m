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
    UIImage *image = [UIImage imageNamed:@"background"];
    self.view.layer.contents = (id) image.CGImage;
    
    _mytableview.delegate = self;
    _mytableview.dataSource = self;
    [_mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //[_mytableview setSeparatorColor:[UIColor colorWithRed:18.0 green:108.0 blue:255.0 alpha:1.0]];
    //[_mytableview setSeparatorInset:UIEdgeInsetsMake(0,50,0,50)];
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
            return 2;
        }
        else if (section == 1)
        {
            return 3;
        }
        else
        {
            return 4;
        }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0&&indexPath.row==0){
        static NSString * MenuCellIdentifier = @"Cell";
        MeunTableViewCell* cell = [_mytableview dequeueReusableCellWithIdentifier:MenuCellIdentifier];
        cell.menuImage.image = [[UIImage alloc]init];
        cell.menuTitle.text = @"USER";
        cell.backgroundColor = [UIColor clearColor];
        //cell被选中后的颜色不变
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString * MenuCellIdentifier = @"Cell";
        MeunTableViewCell* cell = [_mytableview dequeueReusableCellWithIdentifier:MenuCellIdentifier];
        if (cell == nil)
        {
            cell = [[MeunTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MenuCellIdentifier];
        }
        
        cell.menuImage.image = [[UIImage alloc]init];
        cell.menuTitle.text = @"test";
        cell.backgroundColor = [UIColor clearColor];
        //cell被选中后的颜色不变
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0)
        return 20.0f;
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
        return nil;
    }
    else if (section == 1)
    {
        LeftTableViewSectionView *header = [[[NSBundle mainBundle] loadNibNamed: @"MenuTableViewSectionView"
                                                        owner: self
                                                      options: nil] lastObject];
        header.sectionTitle.text = @"SITES";
        header.sectionImage.image = [[UIImage alloc]init];
        [header.addMenu addTarget:self action:@selector(changeMenu) forControlEvents:UIControlEventTouchUpInside];
        return header;
    }else{
        LeftTableViewSectionView *header = [[[NSBundle mainBundle] loadNibNamed: @"MenuTableViewSectionView"
                                                                          owner: self
                                                                        options: nil] lastObject];
        header.sectionTitle.text = @"OTHER";
        header.sectionImage.image = [[UIImage alloc]init];
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
                //聊天
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
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"退出账号"
                                      otherButtonTitles:nil,nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
        return ;
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
