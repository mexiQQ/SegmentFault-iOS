//
//  LeftTableViewUserSectionView.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/12/22.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import "LeftTableViewUserSectionView.h"

@implementation LeftTableViewUserSectionView
@synthesize userAvator = _userAvator;
@synthesize userName = _userName;
@synthesize userResu = _userResu;

- (void)awakeFromNib {
  self.userAvator.layer.masksToBounds = YES;
  self.userAvator.layer.cornerRadius = 5.0;
}

@end
