//
//  CommentStore.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/21.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "CommentStore.h"

@implementation CommentStore
static CommentStore *store = nil;

//单例类
+ (CommentStore *)sharedStore {
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    store = [[self alloc] init];
  });
  return store;
}

- (void)readNewData:(void (^)(NSMutableArray *))block id_:(NSString *)id_ {
  //  NSString *url = [NSString
  //      stringWithFormat:@"http://api.segmentfault.com/comment/show/%@", id_];
  NSString *url = [NSString
      stringWithFormat:@"http://api.lvye.sfdev.com/answer/%@/comments", id_];
  STHTTPRequest *r = [STHTTPRequest requestWithURLString:url];
  [r setCompletionJSONBlock:^(NSDictionary *header, NSDictionary *jsonObj) {
    NSMutableArray *array =
        [[jsonObj objectForKey:@"data"] objectForKey:@"comment"];
    block(array);
  }];
  r.errorBlock = ^(NSError *error) {
    NSLog(@"error is %@", error);
  };
  [r startAsynchronous];
}

@end
