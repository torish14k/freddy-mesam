//
//  QQShare.m
//  NextApp
//
//  Created by wangjun on 12-1-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QQShare.h"

@implementation QQShare

-(void)saveTokenKey:(NSString *)tokenKey
{
    NSUserDefaults *s = [NSUserDefaults standardUserDefaults];
    [s setObject:tokenKey forKey:@"tokenKey"];
    [s synchronize];
}

-(void)saveTokenSecret:(NSString *)tokenSecret
{
    NSUserDefaults *s = [NSUserDefaults standardUserDefaults];
    [s setObject:tokenSecret forKey:@"tokenSecret"];
    [s synchronize];
}

-(NSString *)getTokenKey
{
    NSUserDefaults *s = [NSUserDefaults standardUserDefaults];
    NSString *tokenKey = [s objectForKey:@"tokenKey"];
    return tokenKey == nil ? @"" : tokenKey;
}

-(NSString *)getTokenSecret
{
    NSUserDefaults *s = [NSUserDefaults standardUserDefaults];
    NSString *tokenSecret = [s objectForKey:@"tokenSecret"];
    return tokenSecret == nil ? @"" : tokenSecret;
}



- (void)parseTokenKeyWithResponse:(NSString *)aResponse {
	
	NSDictionary *params = [NSURL parseURLQueryString:aResponse];
	NSString *tokenKey = [params objectForKey:@"oauth_token"];
    NSString *tokenSecret = [params objectForKey:@"oauth_token_secret"];
    [self saveTokenKey:tokenKey];
    [self saveTokenSecret:tokenSecret];
}


//单例模式
static QQShare * instance = nil;
+(QQShare *) Instance
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            [self new];
        }
    }
    return instance;
}
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}
@end
