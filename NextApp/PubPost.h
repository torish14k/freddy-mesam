//
//  PubPost.h
//  NextApp
//
//  Created by wangjun on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Catalog.h"
#import "DataSingleton.h"
#import "Tool.h"
#import "DataProvider.h"
#import "Xml_ApiError.h"
#import "BIDAppDelegate.h"
#import "ImagesView.h"

@interface PubPost : UIViewController<UITextViewDelegate, NSURLConnectionDataDelegate>
{
    int catalogID;
    
    NSMutableData *receivedPubPost;
    UIAlertView *alertPubPost;
}
//发表文章按钮事件
- (IBAction)click_PubPost:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txt_Title;
@property (strong, nonatomic) IBOutlet UITextField *txt_Tags;
@property (strong, nonatomic) IBOutlet UITextView *txt_Body;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Catalog;
- (IBAction)click_ChoseCatalog:(id)sender;

//关闭键盘
-(IBAction)textFieldDoneEditing:(id)sender;
//但现在的问题是点击了背景却被 ScrollView 截断路由事件
-(IBAction)backgroundTap:(id)sender;
//插入图片
- (IBAction)click_InsertImg:(id)sender;
- (IBAction)click_PostList:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_AddImg;

//发表文章
-(void)pubPost;
-(void)pubPostWithImgs;
-(void)pubPost3;

//初始化 
-(void)initControls;


@end
