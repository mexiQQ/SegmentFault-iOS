//
//  ArticleTableViewCell.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *articleTitle;
@property(weak, nonatomic) IBOutlet UILabel *articleExcerpt;
@property(weak, nonatomic) IBOutlet UILabel *articleVote;
@property(weak, nonatomic) IBOutlet UILabel *articleTags;
- (void)configureForCell:(NSMutableDictionary *)item;

@end
