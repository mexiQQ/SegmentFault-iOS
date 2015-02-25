//
//  DetailAnswerTableViewCell.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailAnswerTableViewCell : UITableViewCell <UIWebViewDelegate>
@property(weak, nonatomic) IBOutlet UIView *TopView;
@property(weak, nonatomic) IBOutlet UILabel *authorLabel;
@property(weak, nonatomic) IBOutlet UILabel *authorRateLabel;
@property(weak, nonatomic) IBOutlet UILabel *productTime;
@property(weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property(nonatomic, strong) NSString *indexTag;

- (void)configureForCell:(NSDictionary *)item
                   index:(NSInteger *)indexpath
                accepted:(BOOL)isAccepted;

@property(weak, nonatomic) IBOutlet UILabel *commentLabel;
@property(weak, nonatomic) IBOutlet UIButton *acceptButton;
@property(weak, nonatomic) IBOutlet UIButton *likeButton;
@property(weak, nonatomic) IBOutlet UIButton *hateButton;
@end
