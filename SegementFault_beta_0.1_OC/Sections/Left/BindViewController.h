//
//  BindViewController.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/11.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindViewController : UIViewController <UIWebViewDelegate>

@property(weak, nonatomic) IBOutlet UIWebView *bindWebView;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property(nonatomic, strong) NSString *accessToken;
@end
