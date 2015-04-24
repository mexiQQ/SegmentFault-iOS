//
//  AboutViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/16.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "AboutViewController.h"
#import "UIViewController+MMDrawerController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize aboutContentView = _aboutContentView;
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController.navigationBar
      setBarTintColor:[UIColor colorWithRed:34 / 255.0
                                      green:72 / 255.0
                                       blue:57 / 255.0
                                      alpha:1.0]];

  // 设置 barTitle
  [self.titleButton
      setBackgroundImage:[UIImage imageNamed:@"NavigationBar_title"]
                forState:UIControlStateNormal];

  NSError *error;
  NSString *textFileContents = [NSString
      stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"about"
                                                               ofType:@"html"]
                      encoding:NSUTF8StringEncoding
                         error:&error];
  [self.aboutContentView loadHTMLString:textFileContents
                                baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
- (IBAction)openUrl:(id)sender {
  [[UIApplication sharedApplication]
      openURL:[NSURL URLWithString:@"http://segmentfault.com/"]];
}

- (IBAction)sliderLeft:(id)sender {
  [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft
                                    animated:YES
                                  completion:nil];
}
@end
