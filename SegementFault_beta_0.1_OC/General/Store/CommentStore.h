//
//  CommentStore.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/21.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"

@interface CommentStore : Store
+(CommentStore *)sharedStore;
- (void)readNewData:(void(^)(NSMutableArray *))block id_:(NSString *)id_;
@end
