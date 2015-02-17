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

- (void)readNewData:(void(^)(NSDictionary *,NSDictionary *))block{
    __block NSDictionary *detailArticle = nil;
    __block NSDictionary *detailComment = nil;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        NSError *error = nil;
        STHTTPRequest *r = [STHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.segmentfault.com/article/%@",[ArticleStore sharedStore].currentShowArticleId]]];
        [r startSynchronousWithError:&error];
        NSData *data = r.responseData;
        if(data){
            detailArticle = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        NSError *error = nil;
        STHTTPRequest *r = [STHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.segmentfault.com/comment/show/%@",[ArticleStore sharedStore].currentShowArticleId]]];
        [r startSynchronousWithError:&error];
        NSData *data = r.responseData;
        if(data){
            detailComment = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
    });
    
    dispatch_group_notify(group,dispatch_get_global_queue(0, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            block(detailArticle,detailComment   );
        });
    });

//    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/article/%@",[ArticleStore sharedStore].currentShowArticleId];
//    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
//    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
//        NSDictionary *dic = [jsonObj objectForKey:@"data"];
//        block(dic);
//    }];
//    r.errorBlock = ^(NSError *error) {
//        NSLog(@"error is %@",error);
//    };
//    [r startAsynchronous];
}

@end
