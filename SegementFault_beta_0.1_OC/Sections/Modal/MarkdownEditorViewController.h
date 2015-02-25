//
//  MarkdownEditorViewController.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/20.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BarItemBlock)(NSString *);

@interface MarkdownEditorViewController : UIViewController <UITextViewDelegate>
@property(weak, nonatomic) IBOutlet UIBarButtonItem *leftBarItem;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *rightBarItem;

@property(nonatomic, strong) BarItemBlock rightBarItemBlock;
@property(nonatomic, strong) BarItemBlock leftBarItemBlock;
- (void)setHandler:(BarItemBlock)cancelHandler
       PullHandler:(BarItemBlock)pullHandler;
@end
