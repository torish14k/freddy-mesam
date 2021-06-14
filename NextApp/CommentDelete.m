//
//  CommentDelete.m
//  NextApp
//
//  Created by wangjun on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentDelete.h"

@implementation CommentDelete
@synthesize parent;

-(void)deleteComment:(int)_id
{
    alertView = [Tool getLoadingView:@"载入中" andMessage:@"正在提交删除评论"];
    [alertView show];
    
    NSMutableURLRequest *request = [Tool getHttpRequest:@"GET" andUrl:Config.Instance.api_CommentDel andBody:[NSString stringWithFormat:@"comment=%d", _id] andCookie:[Config.Instance getCookieEntity]];
    
    receivedData = [[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (alertView) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (receivedData) {
        Xml_ApiError *x = [[Xml_ApiError alloc] initWithData:receivedData];
        [x setDelegate:x];
        [x parse];
        switch (x.error.errorCode) {
            case 1:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除成功" message:@"评论删除成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
                if (parent) {
                    [parent reloadComments];
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
}

static CommentDelete * instance = nil;
+(CommentDelete *) Instance
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
