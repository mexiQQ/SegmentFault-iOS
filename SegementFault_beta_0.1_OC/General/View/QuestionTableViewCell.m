//
//  QuestionTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/12/23.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import "QuestionTableViewCell.h"

@implementation QuestionTableViewCell
@synthesize questionTitle = _questionTitle;
@synthesize repuLabel = _repuLabel;
@synthesize tagsLabel = _tagsLabel;

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)configureForCell:(NSMutableDictionary *)item {
  self.questionTitle.text = [item objectForKey:@"title"];
  self.repuLabel.text =
      [NSString stringWithFormat:@"vote:%@", [item objectForKey:@"votes"]];

  NSMutableString *tagString = [[NSMutableString alloc] init];
  NSArray *tags = [item objectForKey:@"tags"];
  for (NSDictionary *tag in tags) {
    [tagString appendFormat:@" %@", [tag objectForKey:@"name"]];
  }
  self.tagsLabel.text = tagString;
}
@end
