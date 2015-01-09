//
//  AticleStore.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"

@interface ArticleStore : Store
+(ArticleStore *)sharedStore;
- (void)readArticleNewData:(void(^)(NSMutableArray *))block;
- (void)readArticleOldData:(void(^)(NSMutableArray *))block page:(int)page;
@end
