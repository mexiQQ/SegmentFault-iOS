//
//  ArticleTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "ArticleTableViewCell.h"

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

- (void)configureForCell:(NSMutableDictionary *)item {
  self.articleTitle.text = [item objectForKey:@"title"];
  self.articleVote.text =
      [NSString stringWithFormat:@"vote:%@", [item objectForKey:@"votes"]];
  self.articleExcerpt.text = [item objectForKey:@"excerpt"];
  NSMutableString *tagString = [[NSMutableString alloc] init];
  NSArray *tags = [item objectForKey:@"tags"];
  for (NSDictionary *tag in tags) {
    [tagString appendFormat:@" %@", [tag objectForKey:@"name"]];
  }
  self.articleTags.text = tagString;
}

@end
