//
//  DetailQuestionStore.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailQuestionStore.h"
@implementation DetailQuestionStore
static DetailQuestionStore *store = nil;

//单例类
+(DetailQuestionStore *)sharedStore
{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        store = [[self alloc] init];
    });
    return store;
}

// 采用 GCD 技术，发起多次异步请求
- (void)readNewData:(void(^)(NSDictionary *,NSDictionary *))block{
    __block NSDictionary *detailQuestion = nil;
    __block NSDictionary *detailAnwser = nil;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        NSError *error = nil;
        STHTTPRequest *r = [STHTTPRequest requestWithURL:[NSURL URLWithString:@"http://api.segmentfault.com/question/1010000002534328"]];
        [r startSynchronousWithError:&error];
        NSData *data = r.responseData;
        if(data){
            detailQuestion = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        NSError *error = nil;
        STHTTPRequest *r = [STHTTPRequest requestWithURL:[NSURL URLWithString:@"http://api.segmentfault.com/answer/show/1010000002534328"]];
        [r startSynchronousWithError:&error];
        NSData *data = r.responseData;
        if(data){
            detailAnwser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
    });
    
    dispatch_group_notify(group,dispatch_get_global_queue(0, 0),^{
        block(detailQuestion,detailAnwser);
    });
    
    /*
    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/question/%@",@"1010000002534328"];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        NSDictionary *dic = [jsonObj objectForKey:@"data"];
        block(dic);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
    */
}

@end