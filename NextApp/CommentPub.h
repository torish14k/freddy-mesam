//
//  CommentPub.h
//  NextApp
//
//  Created by wangjun on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Xml_ApiError.h"
#import "Tool.h"
#import "Config.h"
#import "DataSingleton.h"

@interface CommentPub : UIViewController<UITextViewDelegate, NSURLConnectionDataDelegate>
{
    UIAlertView *alertPubComment;
    NSMutableData *receivedPubComment;
}

@property (strong, nonatomic) IBOutlet UITextField *txt_Name;
@property (strong, nonatomic) IBOutlet UITextField *txt_Email;
@property (strong, nonatomic) IBOutlet UITextField *txt_Website;
@property (strong, nonatomic) IBOutlet UITextView *txt_Body;

#pragma 关闭键盘
-(IBAction)textFieldDoneEditing:(id)sender;
-(IBAction)backgroundTap:(id)sender;

//控件初始化
-(void)initControls;

-(void)initTextFields;

//发表评论
- (IBAction)click_CommentPub:(id)sender;
-(void)pubComment;
//发表成功后 需要保存这个
-(void)saveNameEmailWebsite;

@end
