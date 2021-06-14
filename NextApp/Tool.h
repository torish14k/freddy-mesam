//
//  Tool.h
//  NextApp
//
//  Created by wangjun on 12-1-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Single.h"

@interface Tool : NSObject

+(NSString *)toDate:(NSString *)sourceDate;

+(NSString *)toTimeNoSeconds:(NSString *)sourceTime;

+(NSMutableURLRequest *)getHttpRequest:(NSString *)_httpMethod andUrl:(NSString *)_url andBody:(NSString *)_parameters andCookie:(NSHTTPCookie *)_cookie;

+(UIAlertView *)getLoadingView:(NSString *)title andMessage:(NSString *)message;

@end
