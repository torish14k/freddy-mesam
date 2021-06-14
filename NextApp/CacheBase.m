//
//  CacheBase.m
//  NextApp
//
//  Created by wangjun on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CacheBase.h"

@implementation CacheBase

-(void)initialize:(int)timeSpan
{
    missions = [[NSMutableArray alloc] initWithCapacity:5];
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeSpan target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)enqueue:(AsyncMissionBase *)mission
{
    
}

-(void)onTimer
{
    
}

@end
