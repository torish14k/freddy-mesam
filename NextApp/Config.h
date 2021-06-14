//
//  Config.h
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#define Setting_UserName @"Setting_UserName"
#define Setting_Password @"Setting_Password"
#define Setting_CookieEntity @"Setting_CookieEntity"
#define Comment_UserName @"Comment_UserName"
#define Comment_Email @"Comment_Email"
#define Comment_Website @"Comment_Website"
#define PostlistLayout @"PostlistLayout"
#define IsBrowserHiddenImgs @"IsBrowserHiddenImgs"

#import <Foundation/Foundation.h>

@interface Config : NSObject
{
    //wordpress配置 
    NSString * blog_url_root;
    NSString * blog_title;
    NSString * blog_ApiUrl;
    NSString * version;
    
    //关于我们的配置 
    NSString * about_description;
    
    //手机硬件信息
    NSString * phoneDeviceName;
    NSString * phoneOSVersion;
    
    //Api信息
    NSString * api_Catalogs;
    NSString * api_Posts;
    NSString * api_PostDetail;
    NSString * api_PostPub;
    NSString * api_PostDel;
    NSString * api_Comments;
    NSString * api_CommentPub;
    NSString * api_CommentDel;
    NSString * api_LoginValidate;
}

//初始化加载配置
-(void) LoadXmlSettings;
-(void) LoadPhoneDeviceInfo;

//判断是否登录 以及 注销
-(BOOL) isLogin;
-(void) logOut;

//Http Agent信息
-(NSString *) http_user_agent;

//登录成功后保存用户名以及密码
-(void) saveUserNameAndPassword:(NSString *)userName andPassword:(NSString *)password;
-(void) saveCookieEntity:(NSHTTPCookie *)newCookie;
-(NSString *) getUserName;
-(NSString *) getPassword;
-(NSHTTPCookie *) getCookieEntity;
//发评论时保存评论时的用户配置信息
-(void)saveCommentUserName:(NSString *)commentUserName;
-(void)saveCommentEmail:(NSString *)commentEmail;
-(void)saveCommentWebsite:(NSString *)commentWebsite;
-(NSString *)getCommentUserName;
-(NSString *)getCommentEmail;
-(NSString *)getCommentWebsite;

//获取url的地址
-(NSURL *)getApiUrl:(NSString *)mainApi andParameters:(NSString *)queryString;

//保存与获取当前文章列表显示详情
-(void)savePostListLayout:(int)layout;
-(int)getPostListLayout;
//保存与获取当前是否显示浏览器图片
-(void)saveBrowserHiddenImgs:(BOOL)hidden;
-(BOOL)getBrowserHiddenImgs;

@property (nonatomic,retain) NSString * blog_url_root;
@property (nonatomic,retain) NSString * blog_title;
@property (nonatomic,retain) NSString * blog_ApiUrl;
@property (nonatomic,retain) NSString * version;
@property (nonatomic,retain) NSString * about_description;
@property (nonatomic,retain) NSString * phoneDeviceName;
@property (nonatomic,retain) NSString * phoneOSVersion;
@property (nonatomic,retain) NSString * api_Catalogs;
@property (nonatomic,retain) NSString * api_Posts;
@property (nonatomic,retain) NSString * api_PostDetail;
@property (nonatomic,retain) NSString * api_PostPub;
@property (nonatomic,retain) NSString * api_PostDel;
@property (nonatomic,retain) NSString * api_Comments;
@property (nonatomic,retain) NSString * api_CommentPub;
@property (nonatomic,retain) NSString * api_CommentDel;
@property (nonatomic,retain) NSString * api_LoginValidate;

@property (nonatomic,retain) NSHTTPCookie *cookie;

//单例模式
+(Config *) Instance;
+(id)allocWithZone:(NSZone *)zone;

@end
