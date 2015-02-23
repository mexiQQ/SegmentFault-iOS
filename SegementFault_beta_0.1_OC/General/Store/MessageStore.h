//
//  MessageStore.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/12.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"

@interface MessageStore : Store
+(MessageStore *)sharedStore;
@property (nonatomic,strong) NSString *currentShowArticleId;
- (void)markMessage:(NSString *)id_;
@end
