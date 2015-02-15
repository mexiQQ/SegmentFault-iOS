//
//  MainAticlesTableViewController.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/12/23.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MMDrawerController.h"
#import "ArticlesDataSource.h"
#import "ArticleStore.h"
#import "ArticleTableViewCell.h"
@interface MainAticlesTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@end
