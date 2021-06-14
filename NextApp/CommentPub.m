//
//  CommentPub.m
//  NextApp
//
//  Created by wangjun on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentPub.h"

@implementation CommentPub
@synthesize txt_Name;
@synthesize txt_Email;
@synthesize txt_Website;
@synthesize txt_Body;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [txt_Body setDelegate:self];
}

- (void)viewDidUnload
{
    [self setTxt_Name:nil];
    [self setTxt_Email:nil];
    [self setTxt_Website:nil];
    [self setTxt_Body:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma 关闭键盘
-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
-(IBAction)backgroundTap:(id)sender
{
    [txt_Body resignFirstResponder];
    [txt_Email resignFirstResponder];
    [txt_Name resignFirstResponder];
    [txt_Website resignFirstResponder];
}

//控件初始化
-(void)initControls
{
    txt_Body.layer.borderColor = UIColor.grayColor.CGColor;
    txt_Body.layer.borderWidth = 1;
    //然后设定 TextView 的圆角
    txt_Body.layer.cornerRadius = 6.0;
    txt_Body.layer.masksToBounds = YES;
    txt_Body.clipsToBounds = YES;
}

-(void)initTextFields
{
    if ([self.txt_Name.text isEqualToString:@""]) {
        self.txt_Name.text = [Config.Instance getCommentUserName];
    }
    if ([self.txt_Email.text isEqualToString:@""]) {
        self.txt_Email.text = [Config.Instance getCommentEmail];
    }
    if ([self.txt_Website.text isEqualToString:@""]) {
        self.txt_Website.text = [Config.Instance getCommentWebsite];
    }
}

//发表评论 
- (IBAction)click_CommentPub:(id)sender {
    [self pubComment];
}

-(void)pubComment
{
    //检测邮箱格式
    if (txt_Email.text.length > 0 && [txt_Email.text rangeOfString:@"@"].length <= 0) {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"错误" message:@"您填写的电子邮件格式错误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alertError show];
        return;
    }
    
    alertPubComment = [Tool getLoadingView:@"载入中" andMessage:@"正在发表评论"];
    [alertPubComment show];
    
    NSString *parameter = [NSString stringWithFormat:@"post=%d&name=%@&email=%@&url=%@&body=%@",DataSingleton.Instance.postToShare._id, txt_Name.text, txt_Email.text, txt_Website.text, txt_Body.text];
    NSMutableURLRequest *request = [Tool getHttpRequest:@"POST" andUrl:Config.Instance.api_CommentPub andBody:parameter andCookie:nil];
    receivedPubComment = [[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedPubComment appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (alertPubComment != nil) {
        [alertPubComment dismissWithClickedButtonIndex:0 animated:YES];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   
    if (receivedPubComment != nil) {
        Xml_ApiError *x = [[Xml_ApiError alloc] initWithData:receivedPubComment];
        [x setDelegate:x];
        [x parse];
        switch (x.error.errorCode) {
            case 1:
            {
                //保存用户名 邮箱 以及网址
                [self saveNameEmailWebsite];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发表成功" message:@"评论发表成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;  
            case -2:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发表失败" message:@"没有评论权限" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case -1:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发表失败" message:@"其他错误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
        }

    }
}

-(void)saveNameEmailWebsite
{
    [Config.Instance saveCommentUserName:txt_Name.text];
    [Config.Instance saveCommentEmail:txt_Email.text];
    [Config.Instance saveCommentWebsite:txt_Website.text];
}

#pragma 完成UITextView的方法
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-175, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+175, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    return YES;
}

@end
