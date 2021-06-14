//
//  QQShare.h
//  NextApp
//
//  Created by wangjun on 12-1-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURL+QAdditions.h"
#import "QWeiboAsyncApi.h"

@interface QQShare : NSObject

-(void)saveTokenKey:(NSString *)tokenKey;
-(void)saveTokenSecret:(NSString *)tokenSecret;
-(NSString *)getTokenKey;
-(NSString *)getTokenSecret;

-(void)parseTokenKeyWithResponse:(NSString *)aResponse;

//单例模式
+(QQShare *) Instance;
+(id)allocWithZone:(NSZone *)zone;

@end
