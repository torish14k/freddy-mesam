//
//  BIDAppDelegate.m
//  NextApp
//
//  Created by wangjun on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BIDAppDelegate.h"

@implementation BIDAppDelegate

@synthesize window = _window;
@synthesize rootController;
@synthesize postDetailController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //首先启动项为 TabBar
    [[NSBundle mainBundle] loadNibNamed:@"TabBarController" owner:self options:nil];
    [self.window addSubview:rootController.view];
    //去除 More 以后的 Edit 按钮
    self.rootController.customizableViewControllers = nil;
    
    //本地数据项填充
    [DataSingleton.Instance initialize];
    
    //从plist文件获取信息
    [self initPlist];
    //获取apis  这里最好使用同步的方法
    [self initApis];
//    [self initApisAsync];
    //异步 暂时不需要使用
    //然后获取分类信息
    [self initCatalogs];
    //然后初始化DataSingleton
    [self initDataSingleton];
    //然后初始化控件
    [self initControls];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)initPlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NextApp-Init" ofType:@"plist"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    NSString *blog_title = [dict objectForKey:@"blog_title"];
    NSString *blog_root = [dict valueForKey:@"blog_root"];
    NSString *blog_querystring = [dict valueForKey:@"blog_querystring"];
    NSString *about_description = [dict valueForKey:@"about_description"];           
    NSString *postlistLayout = [dict valueForKey:@"postlistLayout"];
    
//    NSString *blog_title = @"雷锋网";
//    NSString *blog_root = @"http://blog.makingware.com";
//    NSString *blog_querystring = @"http://blog.makingware.com/?nextapp=index";
//    NSString *about_description = @"出问题了这里";           
//    NSString *postlistLayout = @"2";
    
    Config.Instance.blog_title = blog_title;
    Config.Instance.blog_url_root = blog_root;
    Config.Instance.blog_ApiUrl = blog_querystring;
    Config.Instance.about_description = about_description;
    [Config.Instance savePostListLayout:[postlistLayout intValue]];
}

-(void)initApis
{
    UIAlertView *progressAlert = [Tool getLoadingView:@"载入中" andMessage:@"正在获取网站API"];
    [progressAlert show];
    
    NSMutableURLRequest *request = [Tool getHttpRequest:@"GET" andUrl:Config.Instance.blog_ApiUrl andBody:nil andCookie:nil];
    NSHTTPURLResponse *response;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    //注意 & 这个字符传递有问题 所以我们需要专门转换
    NSString *str = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"#"];
    Xml_GetApis *x = [[Xml_GetApis alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [x setDelegate:x];
    [x parse];
    if (x != nil) {
        //反向替换 # 为 &
        x.api_Catalogs = [x.api_Catalogs stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        x.api_CommentDel = [x.api_CommentDel stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        x.api_CommentPub = [x.api_CommentPub stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        x.api_Comments = [x.api_Comments stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        x.api_LoginValidate = [x.api_LoginValidate stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        x.api_PostDel = [x.api_PostDel stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        x.api_PostDetail = [x.api_PostDetail stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        x.api_PostPub = [x.api_PostPub stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        x.api_Posts = [x.api_Posts stringByReplacingOccurrencesOfString:@"#" withString:@"&"];
        
        Config.Instance.version = x.version;
        Config.Instance.api_Catalogs = x.api_Catalogs;
        Config.Instance.api_CommentDel = x.api_CommentDel;
        Config.Instance.api_CommentPub = x.api_CommentPub;
        Config.Instance.api_Comments = x.api_Comments;
        Config.Instance.api_LoginValidate = x.api_LoginValidate;
        Config.Instance.api_PostDel = x.api_PostDel;
        Config.Instance.api_PostDetail = x.api_PostDetail;
        Config.Instance.api_PostPub = x.api_PostPub;
        Config.Instance.api_Posts = x.api_Posts;
    }
    
    [progressAlert dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)initApisAsync
{
    UIAlertView *progressAlert = [Tool getLoadingView:@"载入中" andMessage:@"请稍等..."];
    [progressAlert show];
    
    NSMutableURLRequest *request = [Tool getHttpRequest:@"GET" andUrl:Config.Instance.blog_ApiUrl andBody:nil andCookie:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] 
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               //针对error的处理
                               
                               if (data != nil) {
                                   if (progressAlert != nil) {
                                       [progressAlert dismissWithClickedButtonIndex:0 animated:YES];
                                   }
                                   Xml_GetApis *x = [[Xml_GetApis alloc] initWithData:data];
                                   [x setDelegate:x];
                                   [x parse];
                                   if (x != nil) {
                                       Config.Instance.version = x.version;
                                       Config.Instance.api_Catalogs = x.api_Catalogs;
                                       Config.Instance.api_CommentDel = x.api_CommentDel;
                                       Config.Instance.api_CommentPub = x.api_CommentPub;
                                       Config.Instance.api_Comments = x.api_Comments;
                                       Config.Instance.api_LoginValidate = x.api_LoginValidate;
                                       Config.Instance.api_PostDel = x.api_PostDel;
                                       Config.Instance.api_PostDetail = x.api_PostDetail;
                                       Config.Instance.api_PostPub = x.api_PostPub;
                                       Config.Instance.api_Posts = x.api_Posts;
                                   }
                               }
    }
    ];
}

-(void)initCatalogs
{
    alertCatalogs = [Tool getLoadingView:@"载入中" andMessage:@"获取文章分类"];
    [alertCatalogs show];
    
    //旧版本处理方式
    NSMutableURLRequest *req = [Tool getHttpRequest:@"GET" andUrl:Config.Instance.api_Catalogs andBody:nil andCookie:nil];
    receivedCatalogs = [[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}
//接受NSData数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedCatalogs appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (alertCatalogs) {
        [alertCatalogs dismissWithClickedButtonIndex:0 animated:YES];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (receivedCatalogs != nil) {
        Xml_Catalogs *x = [[Xml_Catalogs alloc] initWithData:receivedCatalogs];
        [x setDelegate:x];
        [x parse];
        if (x.catalogs != nil) {
            DataSingleton.Instance.catalogs = x.catalogs;
        }
    }
}

-(void)initCatalogsAsync:(NSURLResponse *)response andData:(NSData *)result andError:(NSError *)error
{
    
}

-(void)initDataSingleton
{
    DataSingleton.Instance.postToShare = [PostDetail new];
    DataSingleton.Instance.postToShare.relativePosts = [[NSMutableArray alloc] initWithCapacity:30];
}

-(void)initControls
{
    if (Config.Instance.isLogin) {
        [self changeLoginText:YES];
    }
    else
    {
        [self changeLoginText:NO];
    }
}


-(void)changeLoginText:(BOOL)logined
{
    UITabBarItem *loginItem = [rootController.tabBar.items objectAtIndex:3];
    if (loginItem == nil) {
        return;
    }
    if (logined) {
        loginItem.title = @"注销";
        loginItem.image = [UIImage imageNamed:@"menu_logout_icon.png"];
    }
    else
    {
        loginItem.title = @"登录";
        loginItem.image = [UIImage imageNamed:@"menu_login_icon.png"];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
