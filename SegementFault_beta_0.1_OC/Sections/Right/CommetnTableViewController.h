//
//  CommetnTableViewController.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/21.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommetnTableViewController : UITableViewController
@property(nonatomic, strong) NSString *id_;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak, nonatomic) IBOutlet UIButton *titleButton;
@end
