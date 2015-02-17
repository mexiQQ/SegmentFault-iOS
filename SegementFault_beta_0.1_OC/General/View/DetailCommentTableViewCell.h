//
//  DetailCommentTableViewCell.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet UILabel *commentUsername;
@property (weak, nonatomic) IBOutlet UILabel *commentUserRepu;
@property (weak, nonatomic) IBOutlet UIButton *commentLike;

- (void)configureForCell:(NSDictionary *)item;

@end
