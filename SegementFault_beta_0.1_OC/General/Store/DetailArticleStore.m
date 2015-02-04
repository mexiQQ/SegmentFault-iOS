//
//  DetailArticleStore.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailArticleStore.h"

@implementation DetailArticleStore
@synthesize articleHeight = _articleHeight;
@synthesize commentHeight = _commentHeight;
@synthesize isRefreshHeight = _isRefreshHeight;
static DetailArticleStore *store = nil;

//单例类
+(DetailArticleStore *)sharedStore
{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        store = [[self alloc] init];
    });
    return store;
}

- (void)readNewData:(void(^)(NSDictionary *))block{
    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/article/%@",[ArticleStore sharedStore].currentShowArticleId];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        NSDictionary *dic = [jsonObj objectForKey:@"data"];
        block(dic);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}

@end