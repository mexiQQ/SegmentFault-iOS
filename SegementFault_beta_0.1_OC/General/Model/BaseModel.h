//
// Created by shiweifu on 12/16/14.
// Copyright (c) 2014 SF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property(nonatomic, strong) NSDictionary *jsonObj;

- (instancetype)initWithJsonObj:(NSDictionary *)jsonObj;

+ (instancetype)modelWithJsonObj:(NSDictionary *)jsonObj;

- (id)transformTable;
- (id)filter;
- (id)converTypeTable;

@end
