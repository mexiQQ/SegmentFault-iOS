//
//  DetailAnswerTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailAnswerTableViewCell.h"
#import "AnswerModel.h"
#import "DetailquestionStore.h"
#import "MXUtil.h"
@implementation DetailAnswerTableViewCell
@synthesize TopView = _TopView;
@synthesize authorLabel = _authorLabel;
@synthesize authorRateLabel = _authorRateLabel;
@synthesize productTime = _productTime;
@synthesize contentWebView = _contentWebView;
@synthesize indexTag = _indexTag;

- (void)awakeFromNib {
    self.contentWebView.delegate=self;
}

// 配置 cell
- (void)configureForCell:(NSDictionary *)item index:(NSInteger *)indexpath{
    AnswerModel *answerModel = [AnswerModel modelWithJsonObj:item];
    self.authorLabel.text = [answerModel.user objectForKey:@"name"];
    self.authorRateLabel.text =[answerModel.user objectForKey:@"rank"];
    self.productTime.text = answerModel.createdDate;
    self.indexTag = [NSString stringWithFormat:@"answer%d",(int)indexpath];
    [self.contentWebView loadHTMLString:[[MXUtil sharedUtil] formatHTMLFromMarkdown:answerModel.parsedText] baseURL:[[NSBundle mainBundle] bundleURL]];
}

// 计算 webview 的高度并通知重新加载
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // 更新存储的 cell 高度
    CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('foo').offsetHeight"] floatValue];
    documentHeight += height;
    
    if(![DetailQuestionStore sharedStore].answersHeights){
        [DetailQuestionStore sharedStore].answersHeights = [[NSMutableDictionary alloc] init];
    }
    
    if(![[DetailQuestionStore sharedStore].answersHeights objectForKey:self.indexTag] || (documentHeight - ((NSNumber *)[[DetailQuestionStore sharedStore].answersHeights objectForKey:self.indexTag]).floatValue) > 1){
        [[DetailQuestionStore sharedStore].answersHeights setObject:[NSNumber numberWithFloat:documentHeight] forKey:self.indexTag];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshQuestionHeight" object:self userInfo:nil];
    }
}
@end
