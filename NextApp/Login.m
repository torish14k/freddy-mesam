//
//  Login.m
//  NextApp
//
//  Created by wangjun on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Login.h"

@implementation Login
@synthesize lbl_Title;
@synthesize btn_Logout;
@synthesize lbl_UserName;
@synthesize lbl_Password;
@synthesize lbl_Remember;
@synthesize btn_Login;
@synthesize txt_UserName;
@synthesize txt_Password;
@synthesize switch_RememberMe;

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
}
-(void)initControls
{
    NSString *name = [Config.Instance getUserName];
    name = name == nil ? @"" : name;
    NSString *pwd = [Config.Instance getPassword];
    pwd = pwd == nil ? @"" : pwd;
    self.txt_Password.text = pwd;
    self.txt_UserName.text = name;

    if (Config.Instance.isLogin) {
        lbl_Title.text = @"您已经登录";
        btn_Logout.hidden = NO;
        //切换外观
        lbl_UserName.hidden = lbl_Password.hidden = lbl_Remember.hidden = YES;
        txt_Password.hidden = txt_UserName.hidden = YES;
        btn_Login.hidden = YES;
        switch_RememberMe.hidden = YES;
        
        BIDAppDelegate *app = (BIDAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (app) {
            [app changeLoginText:YES];
        }
    }
    else
    {
        lbl_Title.text = @"登录";
        btn_Logout.hidden = YES;
        
        lbl_UserName.hidden = lbl_Password.hidden = lbl_Remember.hidden = NO;
        txt_Password.hidden = txt_UserName.hidden = NO;
        btn_Login.hidden = NO;
        switch_RememberMe.hidden = NO;
        
        BIDAppDelegate *app = (BIDAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (app) {
            [app changeLoginText:NO];
        }
    }
}
- (void)viewDidUnload
{
    [self setTxt_UserName:nil];
    [self setTxt_Password:nil];
    [self setSwitch_RememberMe:nil];
    [self setLbl_Title:nil];
    [self setBtn_Logout:nil];
    [self setLbl_UserName:nil];
    [self setLbl_Password:nil];
    [self setLbl_Remember:nil];
    [self setBtn_Login:nil];
    [super viewDidUnload];
//    [super viewDidAppear:<#(BOOL)#>];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self initControls];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//登录按钮处理  登录处理
- (IBAction)click_Login:(id)sender 
{
    alertLogin = [Tool getLoadingView:@"载入中" andMessage:@"正在登录"];
    [alertLogin show];
    
    NSMutableURLRequest *request = [Tool getHttpRequest:@"POST" 
                                                 andUrl:Config.Instance.api_LoginValidate
                                                 andBody:[NSString stringWithFormat:@"username=%@&pwd=%@&keep_login=%@",txt_UserName.text, txt_Password.text, switch_RememberMe.isSelected ? @"1" : @"0"]
                                                 andCookie:[Config.Instance getCookieEntity]];
    
    receivedLogin = [[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedLogin appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (alertLogin != nil) {
        [alertLogin dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    NSDictionary *headerFields = [(NSHTTPURLResponse *)response allHeaderFields];
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headerFields forURL:[NSURL URLWithString:@"http://blog.makingware.com"]];
    if (cookies != nil && [cookies count] >0) 
    {
        //保存
        [Config.Instance saveCookieEntity:[cookies objectAtIndex:0]];
        Config.Instance.cookie = [cookies objectAtIndex:0];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (receivedLogin != nil) {

        Xml_ApiError *x = [[Xml_ApiError alloc] initWithData:receivedLogin];
        [x setDelegate:x];
        [x parse];;
        /*
         这里需要保存用户名以及密码
         
         如果用户打开 switch 则需要保存
         
         如果用户关闭 switch 则需要清空原来保存的用户名以及密码 
         */
        switch (x.error.errorCode) {
            case 1:
            {
                if (switch_RememberMe.on) 
                {
                    [Config.Instance saveUserNameAndPassword:txt_UserName.text andPassword:txt_Password.text];
                }
                else
                {
                    [Config.Instance saveUserNameAndPassword:nil andPassword:nil];
                }
                //提示用户
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录成功" message:@"恭喜你 登录成功" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                //修改TabBarItem
                BIDAppDelegate *app = (BIDAppDelegate *)[[UIApplication sharedApplication] delegate];
                if (app) {
                    [app changeLoginText:YES];
                }
                
                [alert show];
                [self viewDidAppear:YES];
            }
                break;
            case 0:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"用户名或者密码错误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case -1:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:x.error.errorMessage delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            default:
                break;
        }
    }
}

- (IBAction)click_Logout:(id)sender {
    
    // 消除代码已经测试成功
//    [Config.Instance saveUserNameAndPassword:@"" andPassword:@""];
    [Config.Instance logOut];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注销成功" message:@"您已经成功注销" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    BIDAppDelegate *app = (BIDAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app) {
        [app changeLoginText:NO];
    }

    [alert show];
    [self viewDidAppear:YES];
}


#pragma 关闭键盘
-(IBAction)txtFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
-(IBAction)backgroundTap:(id)sender
{
    [txt_Password resignFirstResponder];
    [txt_UserName resignFirstResponder];
}

#pragma 测试方法

@end


















