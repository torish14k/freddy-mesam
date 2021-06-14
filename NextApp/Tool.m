//
//  Tool.m
//  NextApp
//
//  Created by wangjun on 12-1-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tool.h"


@implementation Tool

+(NSString *)toDate:(NSString *)sourceDate
{
    return [sourceDate substringToIndex:sourceDate.length - 9];
}

+(NSString *)toTimeNoSeconds:(NSString *)sourceTime
{
    return [sourceTime substringToIndex:sourceTime.length - 3];
}

+(NSMutableURLRequest *)getHttpRequest:(NSString *)_httpMethod andUrl:(NSString *)_url andBody:(NSString *)_parameters
    andCookie:(NSHTTPCookie *)_cookie
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:_httpMethod];
    [request setValue:[Config.Instance http_user_agent] forHTTPHeaderField:@"User_Agent"];
    NSURL *url;
    if ([_httpMethod isEqualToString:@"GET"])
    {
        if (_parameters != nil) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&%@",_url,_parameters]];
        }
        else
        {
            url = [NSURL URLWithString:_url];
        }
    }
    else 
    {
        url = [NSURL URLWithString:_url];
        [request setHTTPBody:[_parameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request setURL:url];
    //是否需要cookie
    if (_cookie != nil) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:_cookie];
    }
    //返回 
    return request;
}

+(UIAlertView *)getLoadingView:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *progressAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(121, 80, 37, 37);
    [progressAlert addSubview:activityView];
    [activityView startAnimating];
    return progressAlert;
}

@end
