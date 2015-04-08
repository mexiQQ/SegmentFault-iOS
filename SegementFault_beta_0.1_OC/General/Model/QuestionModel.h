//
//  QuestionModel.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface QuestionModel : BaseModel
@property(nonatomic, strong) NSString *id_;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *votes;
@property(nonatomic, strong) NSString *created;
@property(nonatomic, strong) NSString *createdDate;
@property(nonatomic, strong) NSString *siteId;
@property(nonatomic, strong) NSNumber *isTagFollowing;
@property(nonatomic, strong) NSString *excerpt;
@property(nonatomic, strong) NSNumber *isAccepted;
@property(nonatomic, strong) NSNumber *isBookmarked;
@property(nonatomic, strong) NSNumber *bookmarks;
@property(nonatomic, strong) NSNumber *viewsWord;
@property(nonatomic, strong) NSString *answers;
@property(nonatomic, strong) NSString *originalText;
@property(nonatomic, strong) NSString *parsedText;
@property(nonatomic, strong) NSNumber *isClosed;
@property(nonatomic, strong) NSNumber *isHated;
@property(nonatomic, strong) NSNumber *isLiked;
@property(nonatomic, strong) NSNumber *isFollowed;
@property(nonatomic, strong) NSArray *tags;
@property(nonatomic, strong) NSDictionary *user;
@property(nonatomic, strong) NSDictionary *lastAnswer;
@end
