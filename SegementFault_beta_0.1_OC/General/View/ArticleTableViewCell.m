//
//  ArticleTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import "ArticleModel.h"

@implementation ArticleTableViewCell
@synthesize articleTitle = _articleTitle;
@synthesize articleExcerpt = _articleExcerpt;
@synthesize articleVote = _articleVote;
@synthesize articleTags = _articleTags;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)configureForCell:(NSDictionary *)item {
  ArticleModel *articleModel = [ArticleModel modelWithJsonObj:item];

  self.articleTitle.text = articleModel.title;
  self.articleVote.text =
      [NSString stringWithFormat:@"vote:%@", articleModel.votes];
  self.articleExcerpt.text = articleModel.excerpt;
  NSArray *tags = articleModel.tags;

  // 拼接 tag 字符串
  NSMutableString *tagString = [[NSMutableString alloc] init];
  for (NSDictionary *tag in tags) {
    [tagString appendFormat:@" %@", [tag objectForKey:@"name"]];
  }

  self.articleTags.text = tagString;
}

@end
