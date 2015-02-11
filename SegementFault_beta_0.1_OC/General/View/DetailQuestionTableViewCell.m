//
//  DetailQuestionTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailQuestionTableViewCell.h"
#import "QuestionModel.h"
#import "DetailQuestionStore.h"
#import "MXUtil.h"
@implementation DetailQuestionTableViewCell

@synthesize TopView = _TopView;
@synthesize authorLabel = _authorLabel;
@synthesize authorRateLabel = _authorRateLabel;
@synthesize productTime = _productTime;
@synthesize contentWebView = _contentWebView;
@synthesize TagView = _TagView;
@synthesize questinTitle=_questinTitle;
- (void)awakeFromNib {
    self.contentWebView.delegate = self;
}

// 配置 cell
- (void)configureForCell:(NSDictionary *)item{
    QuestionModel *questionModel = [QuestionModel modelWithJsonObj:[item objectForKey:@"data"]];
    self.authorLabel.text = [questionModel.user objectForKey:@"name"];
    self.authorRateLabel.text =[questionModel.user objectForKey:@"rank"];
    self.productTime.text = questionModel.createdDate;
    self.questinTitle.text = questionModel.title;
    [self.contentWebView loadHTMLString:[[MXUtil sharedUtil] formatHTMLFromMarkdown:questionModel.parsedText] baseURL:[[NSBundle mainBundle] bundleURL]];
}

// 计算 webview 的高度并通知重新加载
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 更新存储的 cell 高度
    CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('foo').offsetHeight"] floatValue];
    documentHeight += height + 20;

    if(![DetailQuestionStore sharedStore].questionHeight || (documentHeight - [DetailQuestionStore sharedStore].questionHeight.floatValue) > 1 ){
        [DetailQuestionStore sharedStore].questionHeight = [NSNumber numberWithFloat:documentHeight];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshQuestionHeight" object:self userInfo:nil];
    }
}
@end
