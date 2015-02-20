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
@interface DetailAnswerTableViewCell()
@property (nonatomic, strong) AnswerModel *answerModel;
@end

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
- (void)configureForCell:(NSDictionary *)item index:(NSInteger *)indexpath accepted:(BOOL) isAccepted{
    self.answerModel = [AnswerModel modelWithJsonObj:item];
    self.authorLabel.text = [self.answerModel.user objectForKey:@"name"];
    self.authorRateLabel.text =[self.answerModel.user objectForKey:@"rank"];
    self.productTime.text = self.answerModel.createdDate;
    [self.likeButton setTitle:self.answerModel.votes forState:UIControlStateNormal];
    self.commentLabel.text = [NSString stringWithFormat:@"%@评论",self.answerModel.comments];
    if(!isAccepted){
        self.acceptButton.hidden = YES;
    }
    
    [self.likeButton addTarget:self action:@selector(liketap:) forControlEvents:UIControlEventTouchUpInside];
    [self.hateButton addTarget:self action:@selector(hatetap:) forControlEvents:UIControlEventTouchUpInside];
    
    // 使用此 tag 表示第几个回答，存储每个答案的高度
    self.indexTag = [NSString stringWithFormat:@"answer%d",(int)indexpath];
    
    [self.contentWebView loadHTMLString:[[MXUtil sharedUtil] formatHTMLFromMarkdown:self.answerModel.parsedText] baseURL:[[NSBundle mainBundle] bundleURL]];
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

- (IBAction)liketap:(id)sender{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        [[DetailQuestionStore sharedStore] likeAnswer:self.answerModel.id_ handle:^(NSDictionary * dic) {
            NSLog(@"%@",dic);
            NSString * status = [dic objectForKey:@"status"];
            if(status.integerValue == 0){
                [self.likeButton setTitle:[dic objectForKey:@"data"] forState:UIControlStateNormal];
            }
        }];
    }else{
        [[MXUtil sharedUtil] showMessageScreen:@"未登录"];
    }
}

- (IBAction)hatetap:(id)sender{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        [[DetailQuestionStore sharedStore] hateAnswer:self.answerModel.id_ handle:^(NSDictionary * dic) {
            NSLog(@"%@",dic);
            NSString * status = [dic objectForKey:@"status"];
            if(status.integerValue == 0){
                [self.likeButton setTitle:[dic objectForKey:@"data"] forState:UIControlStateNormal];
            }
        }];
    }else{
        [[MXUtil sharedUtil] showMessageScreen:@"未登录"];
    }
}
@end
