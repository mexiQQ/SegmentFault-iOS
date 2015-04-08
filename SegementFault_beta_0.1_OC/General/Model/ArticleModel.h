//
//  ArticleModel.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/3/19.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleModel : BaseModel

@property(nonatomic, strong) NSString *id_;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *votes;
@property(nonatomic, strong) NSString *createdDate;
@property(nonatomic, strong) NSString *excerpt;
@property(nonatomic, strong) NSString *comments;
@property(nonatomic, strong) NSString *originalText;
@property(nonatomic, strong) NSString *parsedText;
@property(nonatomic, strong) NSString *currentStatus;
@property(nonatomic, strong) NSArray *tags;

@property(nonatomic, strong) NSDictionary *blog;
@property(nonatomic, strong) NSDictionary *next;
@property(nonatomic, strong) NSDictionary *prev;
@property(nonatomic, strong) NSDictionary *user;

@property(nonatomic, strong) NSNumber *bookmarks;
@property(nonatomic, strong) NSNumber *isTagFollowing;
@property(nonatomic, strong) NSNumber *viewsWord;
@property(nonatomic, strong) NSNumber *isAuthor;
@property(nonatomic, strong) NSNumber *isDeleted;
@property(nonatomic, strong) NSNumber *isHated;
@property(nonatomic, strong) NSNumber *isHidden;
@property(nonatomic, strong) NSNumber *isLiked;
@property(nonatomic, strong) NSNumber *isRecommend;
@end
