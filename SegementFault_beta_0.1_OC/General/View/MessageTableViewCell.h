//
//  MessageTableViewCell.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/12.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *wordTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *titleTextFeild;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)configureForCell:(NSDictionary *)item;

@end
