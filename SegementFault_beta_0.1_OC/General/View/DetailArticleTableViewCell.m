//
//  DetailArticleTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/23.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailArticleTableViewCell.h"
#import "DetailArticleStore.h"
#import <MMMarkdown/MMMarkdown.h>

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

- (void)configureForCell:(NSDictionary *)item{
    // 检测是否为重新加载高度
    if(![DetailArticleStore sharedStore].isRefreshHeight){
        NSDictionary *user = [item objectForKey:@"user"];
        
        self.authorLabel.text = [user objectForKey:@"name"];
        self.authorRateLabel.text =[user objectForKey:@"rank"];
        self.productTime.text = [item objectForKey:@"createdDate"];
        self.articleTitle.text = [item objectForKey:@"title"];
        
        CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [DetailArticleStore sharedStore].articleHeight = [NSNumber numberWithFloat:height];
        
        [self.contentWebView loadHTMLString:[self formatHTML:[item objectForKey:@"originalText"]] baseURL:[[NSBundle mainBundle] bundleURL]];
    }
    [DetailArticleStore sharedStore].isRefreshHeight = false;
}

// 解析 markdown 语法
- (NSString *)formatHTML:(NSString *)str{
    NSError  *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                            pathForResource:@"template"
                                                            ofType:@"html"]
                                                           encoding:NSUTF8StringEncoding
                                                              error: & error];
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:str error:&error];
    htmlString = [NSString stringWithFormat:textFileContents,htmlString];
    return [self rexMake:htmlString];
}

// 计算 webview 的高度并通知重新加载
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat documentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('foo').offsetHeight"] floatValue];
    documentHeight += [DetailArticleStore sharedStore].articleHeight.floatValue + 40;
    [DetailArticleStore sharedStore].articleHeight = [NSNumber numberWithFloat:documentHeight];
    //通知webView 刷新高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHeight" object:self userInfo:nil];
}


// 替换图片链接地址
- (NSString *) rexMake:(NSString *)str{
    NSString *parten2 = @"\\/img\\/\\w+";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten2 options:NSRegularExpressionAnchorsMatchLines error:&error];
    NSArray* match = [reg matchesInString:str options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, [str length])];
    if (match.count != 0){
        for (NSTextCheckingResult *matc in match){
            NSRange range = [matc range];
            [array addObject:[str substringWithRange:range]];
        }
        for(NSString *a in array){
            str = [str stringByReplacingOccurrencesOfString:a withString:[NSString stringWithFormat:@"http://segmentfault.com%@",a]];
        }
    }
    return str;
}

@end
