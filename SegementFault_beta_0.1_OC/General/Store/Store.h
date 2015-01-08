//
//  Store.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STHTTPRequest+JSON.h"
@interface Store : NSObject

+(Store *)sharedStore;

- (void)readNewData:(void(^)(NSMutableArray *))block;
- (void)readOldData:(void(^)(NSMutableArray *))block page:(int)page;
@end
