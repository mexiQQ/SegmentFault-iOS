//
//  CommetnTableViewController.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/21.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageComposerView.h"
@interface CommetnTableViewController
    : UITableViewController <MessageComposerViewDelegate>
@property(nonatomic, strong) NSString *id_;
@property(weak, nonatomic) IBOutlet UIButton *titleButton;
@property(nonatomic, strong) MessageComposerView *messageComposerView;
@end
