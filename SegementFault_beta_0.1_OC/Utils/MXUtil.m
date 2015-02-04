//
//  MXUtil.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "MXUtil.h"
#import "MBProgressHUD.h"
@implementation MXUtil

static MXUtil *util = nil;

//单例类
+(MXUtil *)sharedUtil
{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        util = [[self alloc] init];
    });
    return util;
}

- (void)showMessageScreen:(NSString *)value viewController:(UINavigationController *)controller{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = value;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

@end
