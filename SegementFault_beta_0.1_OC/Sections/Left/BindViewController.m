//
//  BindViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/11.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "BindViewController.h"
#import "UIButton+Bootstrap.h"
@interface BindViewController ()

@end

@implementation BindViewController
@synthesize accessToken = _accessToken;
- (void)viewDidLoad {
  [super viewDidLoad];
  self.bindWebView.delegate = self;

  NSMutableURLRequest *req = [[NSMutableURLRequest alloc]
      initWithURL:[NSURL URLWithString:@"http://segmentfault.com/user/bind"]];
  [self.bindWebView loadRequest:req];
}

- (IBAction)cacelAction:(id)sender {
  NSHTTPCookieStorage *hs = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  [hs deleteCookie:[NSHTTPCookie cookieWithProperties:@{
    @"PHPSESSID" : self.accessToken
  }]];
  [[NSUserDefaults standardUserDefaults] registerDefaults:@{
    @"UserAgent" : @""
  }];
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
