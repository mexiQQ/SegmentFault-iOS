//
//  MessageTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/12.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "MXUtil.h"
@implementation MessageTableViewCell
@synthesize userNameTextFeild = _userNameTextFeild;
@synthesize titleTextFeild = _titleTextFeild;
@synthesize wordTextFeild = _wordTextFeild;
@synthesize timeLabel = _timeLabel;
@synthesize maskLabel = _maskLabel;
- (void)awakeFromNib {

}

// 配置 cell
- (void)configureForCell:(NSDictionary *)item{
    NSDictionary *target = [item objectForKey:@"target"];
    NSArray *users = [target objectForKey:@"users"];
    NSDictionary *user = users[0];
    NSString *viewd = [item objectForKey:@"viewed"];
    
    self.userNameTextFeild.text = [user objectForKey:@"name"];
    self.titleTextFeild.text = [item objectForKey:@"title"];
    self.timeLabel.text = [item objectForKey:@"date"];
    self.wordTextFeild.text = [[target objectForKey:@"word"] substringFromIndex:2];
    
    if(viewd.integerValue == 0){
        self.maskLabel.textColor = [[MXUtil sharedUtil] getUIColor:@"1d953f"];
        self.maskLabel.text = @"未读";
    }else{
        self.maskLabel.text = @"已读";
        self.maskLabel.textColor = [UIColor grayColor];
    }
}

@end
