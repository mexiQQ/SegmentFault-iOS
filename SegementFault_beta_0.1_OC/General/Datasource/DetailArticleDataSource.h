//
//  DetailArticleDataSource.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "ArrayDataSource.h"

@interface DetailArticleDataSource : ArrayDataSource

@property(nonatomic, strong) NSDictionary *articleDic;
@property(nonatomic, strong) NSArray *commentsArray;

- (id)initWithItems:(NSDictionary *)anItem
               andArray:(NSArray *)items
         cellIdentifier:(NSString *)aCellIdentifier
    aconfigureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock
    bconfigureCellBlock:(TableViewCellConfigureBlock)bConfigureCellBlock;

@end
