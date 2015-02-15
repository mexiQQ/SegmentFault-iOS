//
//  MessageDataSource.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/12.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "ArrayDataSource.h"

@interface MessageDataSource : ArrayDataSource
- (id)initWithItems:(NSArray *)anItems
     cellIdentifier:(NSString *)aCellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
@end
