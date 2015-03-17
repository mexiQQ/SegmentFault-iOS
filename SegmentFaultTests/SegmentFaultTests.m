//
//  SegmentFaultTests.m
//  SegmentFaultTests
//
//  Created by MexiQQ on 15/3/17.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Kiwi/Kiwi.h>

SPEC_BEGIN(SimpleStringSpec)

describe(@"SimpleString", ^{
  context(@"when assigned to 'Hello world'", ^{
    NSString *greeting = @"Hello world";
    it(@"should exist", ^{
      [[greeting shouldNot] beNil];
    });

    it(@"should equal to 'Hello world'", ^{
      [[greeting should] equal:@"Hello world"];
    });
  });
});

SPEC_END
