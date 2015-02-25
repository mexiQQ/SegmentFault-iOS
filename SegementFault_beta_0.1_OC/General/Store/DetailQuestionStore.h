//
//  DetailQuestionStore.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"

@interface DetailQuestionStore : Store

@property(nonatomic, strong) NSNumber *questionHeight;
@property(nonatomic, strong) NSMutableDictionary *answersHeights;

+ (DetailQuestionStore *)sharedStore;
- (void)readNewData:(void (^)(NSDictionary *, NSDictionary *))block;
- (void)hateQuestion:(NSString *)id_ handle:(void (^)(NSDictionary *dic))block;
- (void)likeQuestion:(NSString *)id_ handle:(void (^)(NSDictionary *dic))block;
- (void)followQuestion:(NSString *)id_
                handle:(void (^)(NSDictionary *dic))block;
- (void)unfollowQuestion:(NSString *)id_
                  handle:(void (^)(NSDictionary *dic))block;
- (void)hateAnswer:(NSString *)id_ handle:(void (^)(NSDictionary *dic))block;
- (void)likeAnswer:(NSString *)id_ handle:(void (^)(NSDictionary *dic))block;
- (void)answerwQuestion:(NSString *)answerContent
                 handle:(void (^)(NSDictionary *dic))block;
- (void)commentAnswer:(NSString *)commentContent
             answerId:(NSString *)answerId
               handle:(void (^)(NSDictionary *dic))block;

@end
