//
//  AppDelegate.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/11/13.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UITabBarController *mainViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"main"];
    
    UIViewController *leftDrawer = [mainStoryboard instantiateViewControllerWithIdentifier:@"menu"];
    UIViewController * rightDrawer = [[UIViewController alloc] init];
    rightDrawer.view.backgroundColor = [UIColor greenColor];
    
    MMDrawerController* drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:mainViewController
                                            leftDrawerViewController:leftDrawer
                                            rightDrawerViewController:rightDrawer];
    
    [drawerController setMaximumRightDrawerWidth:200.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    window.rootViewController = drawerController;
    [window makeKeyAndVisible];
    return YES;
}
@end
