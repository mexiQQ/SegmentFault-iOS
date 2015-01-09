//
//  EditTagTableViewCell.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/9.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTagTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tagTitle;
@property (weak, nonatomic) IBOutlet UIImageView *tagImage;
@property (weak, nonatomic) IBOutlet UISwitch *tagSwitch;

@end
