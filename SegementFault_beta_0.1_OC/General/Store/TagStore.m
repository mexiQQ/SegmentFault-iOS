//
//  TagStore.m
//  SegementFault_beta_0.1_OC
//
//  Created by MexiQQ on 15/1/9.
//  Copyright (c) 2015年 MexiQQ. All rights reserved.
//

#import "TagStore.h"

@interface TagStore ()
@end

@implementation TagStore
@synthesize currentShowTag = _currentShowTag;
static TagStore *store = nil;

//单例类
+(TagStore *)sharedStore
{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        store = [[self alloc] init];
    });
    return store;
}

- (NSMutableArray *)getCurrentTags{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"tags"]){
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"tags"]];
        return array;
    }else{
        return [[NSMutableArray alloc] init];
    }
}

- (void)setCurrentTags:(NSMutableArray *)array{
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    [standardUserDefault setObject:array forKey:@"tags"];
    [standardUserDefault synchronize];
    [self sendBocast];
}

//通过广播机制在 Tags 改变时更新 Menu 菜单
- (void)sendBocast{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TagsChanged" object:self userInfo:nil];
}

- (NSString *)getCurrentShowTagId{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"tags_id" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    return [dictionary objectForKey:self.currentShowTag];
}
@end
