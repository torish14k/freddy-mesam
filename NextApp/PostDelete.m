//
//  PostDelete.m
//  NextApp
//
//  Created by wangjun on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostDelete.h"

@implementation PostDelete
@synthesize parent;

-(void)deletePost:(int)_id
{
    alertView = [Tool getLoadingView:@"载入中" andMessage:@"正在提交删除文章"];
    [alertView show];
    
    NSMutableURLRequest *request = [Tool getHttpRequest:@"GET" andUrl:Config.Instance.api_PostDel andBody:[NSString stringWithFormat:@"post=%d", _id] andCookie:[Config.Instance getCookieEntity]];
    receiveData = [[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (alertView) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    Xml_ApiError *x = [[Xml_ApiError alloc] initWithData:receiveData];
    [x setDelegate:x];
    [x parse];
    switch (x.error.errorCode) {
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除成功" message:@"文章删除成功" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
            if (parent) {
                [parent reloadPosts];
            }
        }
            break;
        case 0:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"用户未登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case -2:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"没有删除权限" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case -1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"其他错误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
}

static PostDelete * instance = nil;
+(PostDelete *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
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
