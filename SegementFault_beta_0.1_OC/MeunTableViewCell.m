//
//  MeunTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/11/14.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import "MeunTableViewCell.h"

@implementation MeunTableViewCell
@synthesize menuImage = _menuImage;
@synthesize menuTitle = _menuTitle;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
