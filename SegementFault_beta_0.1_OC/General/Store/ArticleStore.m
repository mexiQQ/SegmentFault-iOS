//
//  AticleStore.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "ArticleStore.h"

@implementation ArticleStore
@synthesize currentShowArticleId = _currentShowArticleId;
static  ArticleStore *store = nil;
//单例类
+(ArticleStore *)sharedStore
{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        store = [[self alloc] init];
    });
    return store;
}

- (void)readNewData:(void(^)(NSMutableArray *))block{
    NSString *url = @"";
    if([[TagStore sharedStore] getCurrentShowTagId]){
        url = [NSString stringWithFormat:@"http://api.segmentfault.com/article/tagged/%@",[[TagStore sharedStore] getCurrentShowTagId]];
    }else{
        url = [NSString stringWithFormat:@"http://api.segmentfault.com/article/newest"];
    }
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        NSMutableArray *array = [[jsonObj objectForKey:@"data"] objectForKey:@"rows"];
        block(array);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}

- (void)readOldData:(void(^)(NSMutableArray *))block page:(int)page{
    NSString *url = @"";
    if([[TagStore sharedStore] getCurrentShowTagId]){
        url = [NSString stringWithFormat:@"http://api.segmentfault.com/article/tagged/%@?page=%d",[[TagStore sharedStore] getCurrentShowTagId],page];
    }else{
        url = [NSString stringWithFormat:@"http://api.segmentfault.com/article/newest?page=%d",page];
    }
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        NSMutableArray *array = [[jsonObj objectForKey:@"data"] objectForKey:@"rows"];
        block(array);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}
@end
