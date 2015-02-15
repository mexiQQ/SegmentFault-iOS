//
//  LoginViewController.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/11.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthSignUtil.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate,OAuthSignUtilDelegate>

- (IBAction)cancelAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIButton *LoginButton;
@property (weak, nonatomic) IBOutlet UIImageView *LogoImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfeild;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
