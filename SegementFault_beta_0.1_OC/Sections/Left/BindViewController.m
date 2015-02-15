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
@synthesize registerButton = _registerButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.registerButton sfStyle];
}

- (IBAction)cacelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)bindAction:(id)sender {
    
}

@end
