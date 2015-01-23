//
//  DetailArticleTableViewCell.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailArticleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTime;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UIView *TagView;
- (void)configureForCell:(NSDictionary *)item;

@end
