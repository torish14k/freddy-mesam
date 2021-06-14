//
//  Login.h
//  NextApp
//
//  Created by wangjun on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//测试专用
#import "Xml_Comments.h"
#import "Xml_Catalogs.h"
#import "Xml_Posts.h"
#import "Xml_PostDetail.h"
#import "Xml_ApiError.h"
#import "Comment.h"
#import "Catalog.h"
#import "DataSingleton.h"
#import "ApiError.h"
#import "Tool.h"
#import "BIDAppDelegate.h"

@interface Login : UIViewController<UIActionSheetDelegate, NSURLConnectionDataDelegate>
{
    UIAlertView *alertLogin;
    NSMutableData *receivedLogin;
}

@property (strong, nonatomic) IBOutlet UITextField *txt_UserName;
@property (strong, nonatomic) IBOutlet UITextField *txt_Password;
@property (strong, nonatomic) IBOutlet UISwitch *switch_RememberMe;
- (IBAction)click_Login:(id)sender;
- (IBAction)click_Logout:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Title;
@property (strong, nonatomic) IBOutlet UIButton *btn_Logout;
@property (strong, nonatomic) IBOutlet UILabel *lbl_UserName;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Password;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Remember;
@property (strong, nonatomic) IBOutlet UIButton *btn_Login;

//加载初始化的方法
-(void)initControls;

//关闭键盘
-(IBAction)txtFieldDoneEditing:(id)sender;
-(IBAction)backgroundTap:(id)sender;

@end
