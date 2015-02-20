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
@interface DetailQuestionTableViewCell()
@property (nonatomic,strong) QuestionModel *questionModel;
@end

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
    self.questionModel = [QuestionModel modelWithJsonObj:item];
    self.authorLabel.text = [self.questionModel.user objectForKey:@"name"];
    self.authorRateLabel.text =[self.questionModel.user objectForKey:@"rank"];
    self.productTime.text = self.questionModel.createdDate;
    self.questinTitle.text = self.questionModel.title;
    [self.likeButton setTitle:self.questionModel.votes forState:UIControlStateNormal];
    [self.contentWebView loadHTMLString:[[MXUtil sharedUtil] formatHTMLFromMarkdown:self.questionModel.parsedText] baseURL:[[NSBundle mainBundle] bundleURL]];
    
    [self.likeButton addTarget:self action:@selector(tapLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.hateButton addTarget:self action:@selector(tapHate:) forControlEvents:UIControlEventTouchUpInside];
    
    // 给 label 增加点击事件
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showQuestionComment:)];
    self.commentLabel.userInteractionEnabled=YES;
    [self.commentLabel addGestureRecognizer:tap];
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

// 喜欢操作
- (IBAction)tapLike:(id)sender{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        [[DetailQuestionStore sharedStore] likeQuestion:self.questionModel.id_ handle:^(NSDictionary * dic) {
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

// 讨厌操作
- (IBAction)tapHate:(id)sender{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"token"]){
        [[DetailQuestionStore sharedStore] hateQuestion:self.questionModel.id_ handle:^(NSDictionary * dic) {
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

- (IBAction)showQuestionComment:(id)sender{
    
}
@end
