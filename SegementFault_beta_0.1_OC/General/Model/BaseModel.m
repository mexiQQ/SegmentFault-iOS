//
// Created by shiweifu on 12/16/14.
// Copyright (c) 2014 SF. All rights reserved.
//

#import <ObjectiveSugar/NSDictionary+ObjectiveSugar.h>
#import <objc/runtime.h>
#import "BaseModel.h"

@implementation BaseModel {
}

- (instancetype)initWithJsonObj:(NSDictionary *)jsonObj {
  self = [super init];
  if (self) {
    _jsonObj = jsonObj;
    [_jsonObj each:^(NSString *key, NSString *value) {
      if (![self.filter containsObject:key]) {
        if ([self.transformTable hasKey:key]) {
          [self setValue:_jsonObj[key] forKey:self.transformTable[key]];
        } else {
          // 检查是否有这个属性，如果有给它赋予属性
          if (class_getProperty(self.class, [key UTF8String])) {
            [self setValue:_jsonObj[key] forKey:key];
          }
        }
      }
    }];
  }
  return self;
}

+ (instancetype)modelWithJsonObj:(NSDictionary *)jsonObj {
  return [[self alloc] initWithJsonObj:jsonObj];
}

- (id)transformTable {
  return nil;
}

- (id)filter {
  return nil;
}

- (id)valueForUndefinedKey:(NSString *)key {
  return nil;
}

- (id)converTypeTable {
  return nil;
}
@end
