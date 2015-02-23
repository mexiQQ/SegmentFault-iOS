//
//  AppDelegate.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/11/13.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController *mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainPage"];    
    UIViewController *leftDrawer = [mainStoryboard instantiateViewControllerWithIdentifier:@"menuPage"];
    //UIViewController *rightDrawer = [mainStoryboard instantiateViewControllerWithIdentifier:@"messagePage"];
    UIViewController *rightDrawer = [[UIViewController alloc] init];
    //UIViewController *leftDrawer = [[UIViewController alloc] init];

    MMDrawerController* drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:mainViewController
                                            leftDrawerViewController:leftDrawer
                                            rightDrawerViewController:rightDrawer];
    
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    window.rootViewController = drawerController;
    [window makeKeyAndVisible];
    
    // 注册查看消息的页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readMessage:) name:@"readMessage" object:nil];
    
    [self setupSocial];
    return YES;
}

- (void)setupSocial{
    [ShareSDK registerApp:@"56ba5f6fd108"];//字符串api20为您的ShareSDK的AppKey
    
    //注册微博
    [ShareSDK connectSinaWeiboWithAppKey:@"1742025894"
                               appSecret:@"c18d2bbaf9a6cb9344e994292ebab29f"
                             redirectUri:@"http://segmentfault.com/user/oauth/weibo"];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"1742025894"
                                appSecret:@"c18d2bbaf9a6cb9344e994292ebab29f"
                              redirectUri:@"http://segmentfault.com/user/oauth/weibo"
                              weiboSDKCls:[WeiboSDK class]];
    
    
    //添加QQ应用  注册网址  http://open.qq.com/x
    [ShareSDK connectQQWithQZoneAppKey:@"100522525"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    [ShareSDK connectQQWithAppId:@"100522525" qqApiCls:[QQApiInterface class]];
    
    [ShareSDK connectQZoneWithAppKey:@"100522525"
                           appSecret:@"847a2742c2fe5d6c13e5fbb68967f128"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class]
            tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx3e23410dafa9a06b" appSecret:@"c9323c787d46fe7b2eac56551e1facf0" wechatCls:[WXApi class]];
    
    //Pocket
    [ShareSDK connectPocketWithConsumerKey:@"37105-d32d86350db6a9e907003736"
                               redirectUri:@"pocketapp1234"
     ];
    
    //EvernoteWithType
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
                          consumerKey:@"segmentfault"
                       consumerSecret:@"1a5aa3845a630eec"];
    /*
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeUS
                          consumerKey:@"segmentfault"
                       consumerSecret:@"1a5aa3845a630eec"];
    
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeCN
                          consumerKey:@"segmentfault"
                       consumerSecret:@"1a5aa3845a630eec"];
     */
}

- (void)readMessage:(NSNotification *)notification{
    MMDrawerController *draw = (MMDrawerController *)window.rootViewController;
    if(draw.maximumRightDrawerWidth == [[UIScreen mainScreen] bounds].size.width){
        [draw setMaximumRightDrawerWidth:200];
    }else{
        [draw setMaximumRightDrawerWidth:[[UIScreen mainScreen] bounds].size.width];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
@end
