//
//  QuestionModel.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/8.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

- (id)transformTable {
  return @{ @"id" : @"id_" };
}

- (NSString *)description {
  NSMutableString *description = [NSMutableString
      stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
  [description appendFormat:@"id: %@, title: %@, exceprt: %@, url: %@",
                            self.id_, self.title, self.excerpt, self.url];
  [description appendString:@">"];
  return description;
}
@end
