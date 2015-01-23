//
//  DetailArticleStore.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"

@interface DetailArticleStore : Store
+(DetailArticleStore *)sharedStore;
- (void)readNewData:(void(^)(NSDictionary *))block;

@end
