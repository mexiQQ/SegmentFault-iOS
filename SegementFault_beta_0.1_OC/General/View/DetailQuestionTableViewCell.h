//
//  DetailQuestionTableViewCell.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailQuestionTableViewCell : UITableViewCell<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *TopView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTime;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UIView *TagView;
@property (weak, nonatomic) IBOutlet UILabel *questinTitle;
- (void)configureForCell:(NSDictionary *)item;
@end
