//
//  AsyncMissionNextApp.h
//  NextApp
//
//  Created by wangjun on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncMissionBase.h"

#define MissionType_None 0
#define MissionType_PostDetial 1
#define MissionType_PostList 2
#define MissionType_CommentList 3

@interface AsyncMissionNextApp : AsyncMissionBase
{
    int asyncMissionNextAppType;
}

@property int asyncMissionNextAppType;

@end
