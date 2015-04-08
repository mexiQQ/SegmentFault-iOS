//
//  MessageModel.h
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/12.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "BaseModel.h"

@interface MessageModel : BaseModel
@property(nonatomic, strong) NSString *currentStatus;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *sentence;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *id_;
@property(nonatomic, strong) NSString *viewed;
@property(nonatomic, strong) NSDictionary *object;
@property(nonatomic, strong) NSDictionary *target;
@end
