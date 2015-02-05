//
//  DetailQuestionStore.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"

@interface DetailQuestionStore : Store
+(DetailQuestionStore *)sharedStore;
- (void)readNewData:(void(^)(NSDictionary *,NSDictionary *))block;

@end
