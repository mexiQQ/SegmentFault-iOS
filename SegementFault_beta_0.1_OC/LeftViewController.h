
//  LeftViewController.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/11/14.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeunTableViewCell.h"
#import "LeftTableViewSectionView.h"
#import "LeftTableViewUserSectionView.h"
@interface LeftViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (nonatomic,strong) NSMutableArray *cellContent;
@end
