//
//  MessageStore.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/12.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "MessageStore.h"
#import "MXUtil.h"
@implementation MessageStore
static MessageStore *store = nil;

//单例类
+ (MessageStore *)sharedStore {
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    store = [[self alloc] init];
  });
  return store;
}

- (void)readNewData:(void (^)(NSMutableArray *))block {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
    NSString *url = [NSString
        stringWithFormat:@"http://api.segmentfault.com/user/events?token=%@",
                         [[NSUserDefaults standardUserDefaults]
                             objectForKey:@"token"]];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
      NSString *status = [jsonObj objectForKey:@"status"];
      if (status.integerValue == 0) {
        NSMutableArray *array =
            [[jsonObj objectForKey:@"data"] objectForKey:@"rows"];
        block(array);
      } else {
        [[MXUtil sharedUtil] showMessageScreen:@"Token过期，退出重新登录"];
      }
    }];
    r.errorBlock = ^(NSError *error) {
      NSLog(@"error is %@", error);
    };
    [r startAsynchronous];
  }
}

- (void)markMessage:(NSString *)id_ {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]) {
    NSString *url = [NSString
        stringWithFormat:@"http://api.segmentfault.com/user/event/%@/view",
                         id_];
    STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
    NSString *token =
        [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    [r setPOSTDictionary:@{ @"token" : token }];
    r.completionBlock = nil;
    r.errorBlock = ^(NSError *error) {
      NSLog(@"error is %@", error);
    };
    [r startAsynchronous];
  }
}
@end
