//
//  DetailArticleTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailArticleTableViewCell.h"
#import "DetailArticleStore.h"
#import "MXUtil.h"

@implementation DetailArticleTableViewCell
@synthesize TopView = _TopView;
@synthesize authorLabel = _authorLabel;
@synthesize authorRateLabel = _authorRateLabel;
@synthesize productTime = _productTime;
@synthesize contentWebView = _contentWebView;
@synthesize TagView = _TagView;
@synthesize articleTitle = _articleTitle;
- (void)awakeFromNib {
  self.contentWebView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

// 配置 cell
- (void)configureForCell:(NSDictionary *)item {
  NSDictionary *user = [item objectForKey:@"user"];

  self.authorLabel.text = [user objectForKey:@"name"];
  self.authorRateLabel.text = [user objectForKey:@"rank"];
  self.productTime.text = [item objectForKey:@"createdDate"];
  self.articleTitle.text = [item objectForKey:@"title"];

  // 载入 webview 的内容
  NSString *parsedText = [item objectForKey:@"parsedText"];
  [self.contentWebView
      loadHTMLString:[[MXUtil sharedUtil] formatHTMLFromMarkdown:parsedText]
             baseURL:[[NSBundle mainBundle] bundleURL]];
}

// 计算 webview 的高度并通知重新加载
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // 计算没有载入 webview 时 cell 的高度
  CGFloat height =
      [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

  // 更新存储的 cell 高度
  CGFloat documentHeight =
      [[webView stringByEvaluatingJavaScriptFromString:
                    @"document.getElementById('foo').offsetHeight"] floatValue];
  documentHeight += height + 40;

  if (![DetailArticleStore sharedStore].articleHeight ||
      (documentHeight -
       [DetailArticleStore sharedStore].articleHeight.floatValue) > 1) {
    [DetailArticleStore sharedStore].articleHeight =
        [NSNumber numberWithFloat:documentHeight];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"refreshArticleHeight"
                      object:self
                    userInfo:nil];
  }
}
@end
