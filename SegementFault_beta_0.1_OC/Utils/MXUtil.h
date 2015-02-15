//
//  MXUtil.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXUtil : NSObject
+ (MXUtil *)sharedUtil;
- (void) showMessageScreen:(NSString *)value;
- (NSString *) rexMake:(NSString *)str;
- (NSString *) formatHTMLFromMarkdown:(NSString *)str;
- (UIColor *)getUIColor:(NSString*)hexColorString;
- (id) rexMake:(NSString *)str rex:(NSString *)rex;
@end
