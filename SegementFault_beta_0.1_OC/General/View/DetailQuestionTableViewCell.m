//
//  DetailQuestionTableViewCell.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/4.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "DetailQuestionTableViewCell.h"
#import "QuestionModel.h"
#import "AnswerModel.h"

@implementation DetailQuestionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureForCell:(NSDictionary *)item{
    NSDictionary *question = [item objectForKey:@"question"];
    NSDictionary *answers = [[[item objectForKey:@"answer"] objectForKey:@"data"] objectForKey:@"available"];
    
    QuestionModel *questionModel = [QuestionModel modelWithJsonObj:[question objectForKey:@"data"]];
    NSMutableArray *answersModel = [[NSMutableArray alloc] init];
    for(id item in answers){
        [answersModel addObject:[AnswerModel modelWithJsonObj:item]];
    }
    
    self.authorLabel.text = [questionModel.user objectForKey:@"name"];
    self.authorRateLabel.text =[questionModel.user objectForKey:@"rank"];
    self.productTime.text = questionModel.createdDate;

}

@end
