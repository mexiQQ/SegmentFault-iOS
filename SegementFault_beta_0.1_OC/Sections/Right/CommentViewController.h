//
//  CommentViewController.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/4/9.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageComposerView.h"
@interface CommentViewController
    : UIViewController <MessageComposerViewDelegate, UITableViewDelegate,
                        UITextViewDelegate>
@property(nonatomic, strong) MessageComposerView *messageComposerView;
@property(weak, nonatomic) IBOutlet UITableView *mytableView;
@property(strong, nonatomic) IBOutlet UIView *myview;
@property(nonatomic, strong) NSString *id_;
@end
