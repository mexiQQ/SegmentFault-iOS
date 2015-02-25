//
//  TagStore.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/9.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"

@interface TagStore : Store
+ (TagStore *)sharedStore;

@property(nonatomic, strong) NSString *currentShowTag;
- (NSMutableArray *)getCurrentTags;
- (void)setCurrentTags:(NSMutableArray *)array;
- (NSString *)getCurrentShowTagId;
- (void)sendBocast;
@end
