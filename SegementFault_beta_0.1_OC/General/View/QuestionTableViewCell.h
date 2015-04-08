//
//  QuestionTableViewCell.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 14/12/23.
//  Copyright (c) 2014年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *questionTitle;
@property(weak, nonatomic) IBOutlet UILabel *repuLabel;
@property(weak, nonatomic) IBOutlet UILabel *tagsLabel;
- (void)configureForCell:(NSDictionary *)item;

@end
