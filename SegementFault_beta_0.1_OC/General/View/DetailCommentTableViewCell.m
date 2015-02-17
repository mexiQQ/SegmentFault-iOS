//
//  DetailCommentTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailCommentTableViewCell.h"

@implementation DetailCommentTableViewCell
@synthesize commentContent = _commentContent;
@synthesize commentLike = _commentLike;
@synthesize commentUsername = _commentUsername;
@synthesize commentUserRepu = _commentUserRepu;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// 配置 cell
- (void)configureForCell:(NSDictionary *)item{
    self.commentContent.text = [item objectForKey:@"originalText"];
    self.commentUsername.text = [[item objectForKey:@"user"] objectForKey:@"name"];
    self.commentUserRepu.text = [item objectForKey:@"createdDate"];
    [self.commentLike setTitle:[item objectForKey:@"votes" ] forState:UIControlStateNormal];
}

@end
