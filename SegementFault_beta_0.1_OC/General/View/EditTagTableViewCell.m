//
//  EditTagTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/9.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "EditTagTableViewCell.h"

@implementation EditTagTableViewCell
@synthesize tagTitle = _tagTitle;
@synthesize tagImage = _tagImage;
@synthesize tagSwitch = _tagSwitch;

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
