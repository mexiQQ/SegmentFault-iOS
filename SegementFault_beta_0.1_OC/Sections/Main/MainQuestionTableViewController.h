//
//  MainQuestionTableTableViewController.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionsDataSource.h"
#import "QuestionStore.h"
#import "QuestionTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
@interface MainQuestionTableViewController : UITableViewController

@property(weak, nonatomic) IBOutlet UIButton *titleButton;
@end
