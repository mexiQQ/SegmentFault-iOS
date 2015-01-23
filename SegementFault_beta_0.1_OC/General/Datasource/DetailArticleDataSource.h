//
//  DetailArticleDataSource.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "ArrayDataSource.h"

@interface DetailArticleDataSource : ArrayDataSource

@property (nonatomic, strong) NSDictionary *item;

- (id)initWithItems:(NSDictionary *)anItem
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

@end
