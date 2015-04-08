//
//  MessageModel.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/2/12.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (id)transformTable {
  return @{ @"id" : @"id_" };
}

- (NSString *)description {
  NSMutableString *description = [NSMutableString
      stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
  [description appendFormat:@"id: %@, title: %@,  url: %@", self.id_,
                            self.title, self.url];
  [description appendString:@">"];
  return description;
}
@end
