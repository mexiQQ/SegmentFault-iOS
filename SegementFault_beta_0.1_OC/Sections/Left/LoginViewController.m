//
//  LoginViewController.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/11.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "MXUtil.h"
#import "LoginViewController.h"
#import "UIButton+Bootstrap.h"
#import "STHTTPRequest+JSON.h"
#import <ShareSDK/ShareSDK.h>
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()
@property (nonatomic,strong) NSString *userEmail;
@property (nonatomic,strong) NSString *usrpassWord;
@end

@implementation LoginViewController
@synthesize LoginButton=_LoginButton;
@synthesize userView=_userView;
@synthesize LogoImageView=_LogoImageView;
@synthesize emailTextfeild = _emailTextfeild;
@synthesize password = _password;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupView];
    
    self.emailTextfeild.delegate=self;
    self.password.delegate=self;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)setupView{
    self.activityIndicator.hidden = YES;
    
    self.userView.layer.masksToBounds = YES;
    self.userView.layer.cornerRadius = 5.0;
    
    CALayer *line = [[CALayer alloc] init];
    line.borderWidth=1.0f;
    [line setFrame:CGRectMake(2,self.emailTextfeild.bounds.origin.y+self.emailTextfeild.bounds.size.height+4,self.userView.bounds.size.width-4,1)];
    line.borderColor = [[MXUtil sharedUtil] getUIColor:@"D8D8D8"].CGColor;
    [self.userView.layer addSublayer:line];
    
    [_LoginButton sfStyle];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    self.userEmail = self.emailTextfeild.text;
    self.usrpassWord = self.password.text;
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:@"http://api.segmentfault.com/user/login"];
    [r setPOSTDictionary:@{@"mail": self.userEmail, @"password": self.usrpassWord}];
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        NSLog(@"%@",jsonObj);
        self.activityIndicator.hidden = YES;
        NSNumber *status = [jsonObj objectForKey:@"status"];
        if(status.integerValue == 0){
            [[MXUtil sharedUtil] showMessageScreen:@"登录成功"];
            NSDictionary *data = [jsonObj objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"user"] forKey:@"user"];
            [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"token"] forKey:@"token"];
            NSLog(@"json is %@",jsonObj);
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:self userInfo:nil];
            }];
        }else{
            [[MXUtil sharedUtil] showMessageScreen:@"账号密码不匹配"];
        }
    }];
    r.errorBlock = ^(NSError *error) {
        self.activityIndicator.hidden = YES;
        [[MXUtil sharedUtil] showMessageScreen:@"登录失败"];
    };
    [r startAsynchronous];
}

- (IBAction)githubLoginAction:(id)sender {
    [[OAuthSignUtil sharedOAuthSignUtil] signInto:SignIntoGithub viewController:self ];
    [OAuthSignUtil sharedOAuthSignUtil].oAuthDelegate = self;

}

- (IBAction)googleLoginAction:(id)sender {
    [[OAuthSignUtil sharedOAuthSignUtil] signInto:SignIntoGoogle viewController:self ];
    [OAuthSignUtil sharedOAuthSignUtil].oAuthDelegate = self;
}

- (IBAction)weiboLoginAction:(id)sender {
    //powerByHidden:这个参数是去掉授权界面Powered by ShareSDK的标志
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if(result){
                                   id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
                                   NSLog(@"token is %@",[credential token]);
                                   [self thirdLogin:[credential token] type:@"weibo"];
                               }
                           }];
}
- (IBAction)qqLoginAction:(id)sender {
    //powerByHidden:这个参数是去掉授权界面Powered by ShareSDK的标志
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace
                      authOptions:authOptions
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if(result){
                                   id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeQQSpace];
                                   NSLog(@"token is %@",[credential token]);
                                   [self thirdLogin:[credential token] type:@"qq"];
                               }
                           }];
}

- (IBAction)registerAction:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://segmentfault.com/user/register"]];
}

- (IBAction)findPasswordAction:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://segmentfault.com/user/forgot"]];
}

// MXOAurhUtil callback
-(void)didFinishOAuthSign:(NSString *)type accessToken:(NSString *) accessToken{
    NSLog(@"type is %@ accessToken =%@",type,accessToken);
    [self thirdLogin:accessToken type:type];
}

// 第三方获取 token 后请求用户信息
- (void)thirdLogin:(NSString *)access_Token type:(NSString *)type{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:@"http://api.segmentfault.com/user/oauth"];
    [r setPOSTDictionary:@{@"accessToken": access_Token, @"type": type}];
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        self.activityIndicator.hidden = YES;
        NSNumber *status = [jsonObj objectForKey:@"status"];
        NSLog(@"userInfo is %@",jsonObj);
        if(status.integerValue == 0){
            [[MXUtil sharedUtil] showMessageScreen:@"登录成功"];
            NSDictionary *data = [jsonObj objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"user"] forKey:@"user"];
            [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"token"] forKey:@"token"];
            
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccess" object:self userInfo:nil];
            }];
        }else{
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *loginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"bind"];
            loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:loginViewController animated:YES completion:nil];
        }
    }];
    r.errorBlock = ^(NSError *error) {
        self.activityIndicator.hidden = YES;
        [[MXUtil sharedUtil] showMessageScreen:@"登录失败"];
    };
    [r startAsynchronous];
}

#pragma mark - TextField delegate

- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [self.emailTextfeild resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.emailTextfeild)
    {
        [self.password becomeFirstResponder];
    }
    else if(textField == self.password)
    {
        [self.password resignFirstResponder];
    }
    return YES;
}

@end
