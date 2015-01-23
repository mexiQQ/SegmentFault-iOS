//
//  DetailArticleTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailArticleTableViewCell.h"

@implementation DetailArticleTableViewCell
@synthesize TopView = _TopView;
@synthesize authorLabel = _authorLabel;
@synthesize authorRateLabel = _authorRateLabel;
@synthesize productTime = _productTime;
@synthesize contentWebView = _contentWebView;
@synthesize TagView = _TagView;

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)configureForCell:(NSDictionary *)item{
    NSDictionary *tags = [item objectForKey:@"tags"];
    NSDictionary *user = [item objectForKey:@"user"];
    
    self.authorLabel.text = [user objectForKey:@"name"];
    self.authorRateLabel.text =[user objectForKey:@"rank"];
    self.productTime.text = [item objectForKey:@"createdDate"];
    
    [self.contentWebView loadHTMLString:@"<html><body>老婆，我想你</body></html>" baseURL:nil];
    NSLog(@"text is %@",[item objectForKey:@"originalText"]);
}
@end
