//
//  MXUtil.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXUtil : NSObject
+ (MXUtil *)sharedUtil;
- (void)showMessageScreen:(NSString *)value viewController:(UINavigationController *)controller;
@end
