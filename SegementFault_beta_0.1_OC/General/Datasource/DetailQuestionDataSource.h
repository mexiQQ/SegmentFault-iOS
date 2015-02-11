//
//  DetailQuestionDataSource.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "ArrayDataSource.h"

@interface DetailQuestionDataSource : ArrayDataSource<UITableViewDelegate>

@property (nonatomic, strong) NSArray *items;

- (id)initWithItems:(NSArray *)anItem
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

@end
