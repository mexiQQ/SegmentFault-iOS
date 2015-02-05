//
//  AnswerModel.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/5.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseModel.h"
@interface AnswerModel :BaseModel
@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) NSDictionary *access;
@property (nonatomic, strong) NSString     *comments;
@property (nonatomic, strong) NSString     *createdDate;
@property (nonatomic, strong) NSString     *editUrl;
@property (nonatomic, strong) NSString     *id_;
@property (nonatomic, strong) NSString     *isEdited;
@property (nonatomic, strong) NSNumber     *isAuthor;
@property (nonatomic, strong) NSNumber     *isHated;
@property (nonatomic, strong) NSNumber     *isLiked;
@property (nonatomic, strong) NSNumber     *isModified;
@property (nonatomic, strong) NSNumber     *accepted;
@property (nonatomic, strong) NSString     *modifiedDate;
@property (nonatomic, strong) NSString     *originalText;
@property (nonatomic, strong) NSString     *parsedText;
@property (nonatomic, strong) NSString     *revision;
@property (nonatomic, strong) NSString     *shortUrl;
@property (nonatomic, strong) NSString     *url;
@property (nonatomic, strong) NSString     *votes;
@property (nonatomic, assign) CGFloat      prepareHeight;
@end
