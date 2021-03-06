//
//  QuestionStore.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"
#import "TagStore.h"

@interface QuestionStore : Store
@property(nonatomic, strong) NSString *currentShowQuestionId;

+ (QuestionStore *)sharedStore;
- (void)readNewData:(void (^)(NSMutableArray *))block;
- (void)readOldData:(void (^)(NSMutableArray *))block page:(int)page;
@end
