//
//  DetailArticleStore.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "Store.h"
#import "ArticleStore.h"
#import <UIKit/UIKit.h>
@interface DetailArticleStore : Store

@property (nonatomic,strong) NSNumber *articleHeight;
@property (nonatomic,strong) NSNumber *commentHeight;
@property (nonatomic) BOOL isRefreshHeight;

+(DetailArticleStore *)sharedStore;
- (void)readNewData:(void(^)(NSDictionary *))block;

@end
