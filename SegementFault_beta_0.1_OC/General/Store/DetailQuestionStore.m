//
//  DetailQuestionStore.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailQuestionStore.h"
#import "QuestionStore.h"

@implementation DetailQuestionStore
@synthesize questionHeight = _questionHeight;
@synthesize answersHeights = _answersHeights;

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
        STHTTPRequest *r = [STHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.segmentfault.com/question/%@?token=%@",[QuestionStore sharedStore].currentShowQuestionId,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]]]];
        [r startSynchronousWithError:&error];
        NSData *data = r.responseData;
        if(data){
            detailQuestion = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0,0), ^{
        NSError *error = nil;
        STHTTPRequest *r = [STHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.segmentfault.com/answer/show/%@",[QuestionStore sharedStore].currentShowQuestionId]]];
        [r startSynchronousWithError:&error];
        NSData *data = r.responseData;
        if(data){
            detailAnwser = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
    });
    
    dispatch_group_notify(group,dispatch_get_global_queue(0, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            block(detailQuestion,detailAnwser);
        });
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

- (void)hateQuestion:(NSString *)id_ handle:(void(^)(NSDictionary * dic)) block{
    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/question/%@/hate?token=%@",id_,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    r.POSTDictionary=@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        block(jsonObj);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}

- (void)likeQuestion:(NSString *)id_ handle:(void(^)(NSDictionary *dic)) block;{
    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/question/%@/like?token=%@",id_,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    r.POSTDictionary=@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        block(jsonObj);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}

- (void)followQuestion:(NSString *)id_ handle:(void(^)(NSDictionary *dic)) block{
    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/question/%@/follow?token=%@",id_,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    r.POSTDictionary=@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        block(jsonObj);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}

- (void)unfollowQuestion:(NSString *)id_ handle:(void(^)(NSDictionary *dic)) block{
    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/question/%@/unfollow?token=%@",id_,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    r.POSTDictionary=@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        block(jsonObj);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}

- (void)hateAnswer:(NSString *)id_ handle:(void(^)(NSDictionary *dic)) block{
    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/answer/%@/hate?token=%@",id_,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    r.POSTDictionary=@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        block(jsonObj);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}

- (void)likeAnswer:(NSString *)id_ handle:(void(^)(NSDictionary *dic)) block{
    NSString *url = [NSString stringWithFormat:@"http://api.segmentfault.com/answer/%@/like?token=%@",id_,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    r.POSTDictionary=@{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        block(jsonObj);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}

- (void)answerwQuestion:(NSString *)answerContent handle:(void(^)(NSDictionary *dic)) block{
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:@"http://api.segmentfault.com/answer/post"];
    [r setPOSTDictionary:@{@"text": answerContent, @"questionId": [QuestionStore sharedStore].currentShowQuestionId, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]}];
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        block(jsonObj);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];
}

- (void)commentAnswer:(NSString *)commentContent answerId:(NSString *)answerId handle:(void(^)(NSDictionary *dic)) block{
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:@"http://api.segmentfault.com/comment/post"];
    [r setPOSTDictionary:@{@"text": commentContent, @"id": answerId, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]}];
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
        block(jsonObj);
    }];
    r.errorBlock = ^(NSError *error) {
        NSLog(@"error is %@",error);
    };
    [r startAsynchronous];

}
@end
