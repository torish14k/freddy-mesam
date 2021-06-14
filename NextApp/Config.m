//
//  Config.m
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Config.h"

@implementation Config

@synthesize blog_url_root;
@synthesize blog_title;
@synthesize blog_ApiUrl;
@synthesize version;
@synthesize about_description;
@synthesize phoneOSVersion;
@synthesize phoneDeviceName;
@synthesize api_Catalogs;
@synthesize api_Posts;
@synthesize api_PostDetail;
@synthesize api_PostPub;
@synthesize api_PostDel;
@synthesize api_Comments;
@synthesize api_CommentPub;
@synthesize api_CommentDel;
@synthesize api_LoginValidate;

@synthesize cookie;

-(void) LoadXmlSettings
{
}
-(void) LoadPhoneDeviceInfo
{
}

-(BOOL) isLogin
{
    NSHTTPCookie *_cookie = [self getCookieEntity];
    if (_cookie != nil && _cookie.value != nil && ![_cookie.value isEqualToString:@""]) 
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void) logOut
{
    [self saveCookieEntity:nil];
}

-(NSString *) http_user_agent
{
    return @"NextApp/iPhone4/IOS5 (http://www.nextapp.cn)";
}

-(void)saveUserNameAndPassword:(NSString *)newUserName andPassword:(NSString *)newPassword
{
    //使用独立存储技术
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:Setting_UserName];
    [settings removeObjectForKey:Setting_Password];
    [settings setObject:newUserName forKey:Setting_UserName];
    [settings setObject:newPassword forKey:Setting_Password];
    [settings synchronize];
}
-(void)saveCookieEntity:(NSHTTPCookie *)newCookie
{
    //使用独立存储技术 
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newCookie];
    [settings setObject:data forKey:Setting_CookieEntity];
    [settings synchronize];
}
-(NSString *)getUserName
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:Setting_UserName];
}
-(NSString *)getPassword
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:Setting_Password];
}
-(NSHTTPCookie *)getCookieEntity
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSData *data = [settings objectForKey:Setting_CookieEntity];
    NSHTTPCookie *_cookie = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return _cookie;
}

-(void)saveCommentUserName:(NSString *)newCommentUserName
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:Comment_UserName];
    [settings setObject:newCommentUserName forKey:Comment_UserName];
    [settings synchronize];
}
-(void)saveCommentEmail:(NSString *)newCommentEmail
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:Comment_Email];
    [settings setObject:newCommentEmail forKey:Comment_Email];
    [settings synchronize];
}
-(void)saveCommentWebsite:(NSString *)newCommentWebsite
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:Comment_Website];
    [settings setObject:newCommentWebsite forKey:Comment_Website];
    [settings synchronize];
}
-(NSString *)getCommentUserName
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:Comment_UserName];
}
-(NSString *)getCommentEmail
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *email = [settings objectForKey:Comment_Email];
    return email;
}
-(NSString *)getCommentWebsite
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:Comment_Website];
}
-(NSURL *)getApiUrl:(NSString *)mainApi andParameters:(NSString *)queryString
{
    NSString *url = [NSString stringWithFormat:@"%@&%@",mainApi,queryString];
    return [NSURL URLWithString:url];
}

-(void)savePostListLayout:(int)layout
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:PostlistLayout];
    [settings setObject:[NSString stringWithFormat:@"%d",layout] forKey:PostlistLayout];
    [settings synchronize];
}
-(int)getPostListLayout
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *result = [settings objectForKey:PostlistLayout];
    return result == nil ? 1 : [result intValue];
}
-(void)saveBrowserHiddenImgs:(BOOL)hidden
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:IsBrowserHiddenImgs];
    [settings setObject:hidden?@"1":@"0" forKey:IsBrowserHiddenImgs];
    [settings synchronize];
}
-(BOOL)getBrowserHiddenImgs
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString *result = [settings objectForKey:IsBrowserHiddenImgs];
    return result == nil ? NO : [result isEqualToString:@"1"];
}

//单例模式
static Config * instance = nil;
+(Config *) Instance
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
