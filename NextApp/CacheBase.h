//
//  CacheBase.h
//  NextApp
//
//  Created by wangjun on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncMissionBase.h"

@interface CacheBase : NSObject
{
    NSTimer * _timer;
    NSMutableArray * missions;
}

-(void)initialize:(int)timeSpan;

-(void)enqueue:(AsyncMissionBase *)mission;


@end
