//
//  MessageTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/12.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell
@synthesize userNameTextFeild = _userNameTextFeild;
@synthesize titleTextFeild = _titleTextFeild;
@synthesize wordTextFeild = _wordTextFeild;
@synthesize timeLabel = _timeLabel;
- (void)awakeFromNib {

}

// 配置 cell
- (void)configureForCell:(NSDictionary *)item{
    NSDictionary *target = [item objectForKey:@"target"];
    NSArray *users = [target objectForKey:@"users"];
    NSDictionary *user = users[0];
    self.userNameTextFeild.text = [user objectForKey:@"name"];
    self.titleTextFeild.text = [item objectForKey:@"title"];
    self.timeLabel.text = [item objectForKey:@"date"];
    self.wordTextFeild.text = [[target objectForKey:@"word"] substringFromIndex:2];
}

@end
