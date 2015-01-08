//
// Created by shiweifu on 12/16/14.
// Copyright (c) 2014 SF. All rights reserved.
//

#import "STHTTPRequest+JSON.h"

@implementation STHTTPRequest (JSON)

- (void)setCompletionJSONBlock:(void (^) (NSDictionary *header, NSDictionary *jsonObj))completion
{
    completionDataBlock_t block = ^(NSDictionary *headers, NSData *data){
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        completion(headers, response);
    };
    [self setCompletionDataBlock:block];
}

@end