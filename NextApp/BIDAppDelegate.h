//
//  BIDAppDelegate.h
//  NextApp
//
//  Created by wangjun on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"
#import "DataSingleton.h"
#import "Config.h"
#import "Xml_GetApis.h"
#import "Xml_Catalogs.h"
#import "PostDetail.h"
#import "Config.h"

@interface BIDAppDelegate : UIResponder <UIApplicationDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData *receivedCatalogs;
    UIAlertView *alertCatalogs;
}

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (strong, nonatomic) IBOutlet UITabBarController *rootController;

@property (strong, nonatomic) IBOutlet UITabBarController *postDetailController;

-(void)initPlist;

-(void)initApis;

-(void)initApisAsync;

-(void)initCatalogs;
-(void)initCatalogsAsync:(NSURLResponse *)response andData:(NSData *)result andError:(NSError *)error;

-(void)initDataSingleton;

-(void)initControls;
//用户登录或者注销后需要改变这个字符
-(void)changeLoginText:(BOOL)logined;

@end
