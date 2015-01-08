//
//  Store.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"

@implementation Store

static Store *store = nil;

//单例类
+(Store *)sharedStore
{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        store = [[self alloc] init];
    });
    return store;
}

- (void)readNewData:(void(^)(NSMutableArray *))block{
}
- (void)readOldData:(void(^)(NSMutableArray *))block page:(int)page{
}
@end
