//
// Created by shiweifu on 12/16/14.
// Copyright (c) 2014 SF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STHTTPRequest.h"

@interface STHTTPRequest (JSON)

- (void)setCompletionJSONBlock:(void (^)(NSDictionary *header,
                                         NSDictionary *jsonObj))completion;

@end