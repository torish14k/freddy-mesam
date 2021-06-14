//
//  PubPost.m
//  NextApp
//
//  Created by wangjun on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PubPost.h"
#import "DataSingleton.h"

#define BOUNDARY @"AaB03x"
#define MPboundary @"--AaB03x"
#define endMPboundary @"--AaB03x--"

@implementation PubPost
@synthesize btn_AddImg;
@synthesize txt_Title;
@synthesize txt_Tags;
@synthesize txt_Body;
@synthesize lbl_Catalog;

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
//    txt_Body.delegate= self;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self initControls];
//    self.view.center = CGPointMake(120, 100);
    [txt_Body setContentOffset:CGPointMake(0, 100)];
}
-(void)initControls
{
    txt_Body.layer.borderColor = UIColor.grayColor.CGColor;
    txt_Body.layer.borderWidth = 1;
    [txt_Body setDelegate:self];
    
    //然后设定 TextView 的圆角
    txt_Body.layer.cornerRadius = 6.0;
    txt_Body.layer.masksToBounds = YES;
    txt_Body.clipsToBounds = YES;
    
    //如果没有登录则弹出提示
    if ([Config.Instance isLogin] == NO) {

        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请登录后发表文章" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"登录", nil];
        [sheet showInView:self.view];
    }

    //初始化分类信息
    Catalog *firstCatalog = [DataSingleton.Instance.catalogs objectAtIndex:0];
    if (firstCatalog != nil) {
        //
        self.lbl_Catalog.text = firstCatalog.name;
        catalogID = firstCatalog._id;
    }
    
    //初始化添加图片按钮的文本
    if ([DataSingleton.Instance.imgs count] > 0) {

        btn_AddImg.titleLabel.text=[NSString stringWithFormat:@" +图片(%d)", [DataSingleton.Instance.imgs count]];
    }
}

- (void)viewDidUnload
{
    [self setTxt_Title:nil];
    [self setTxt_Body:nil];
    [self setTxt_Tags:nil];
    [self setLbl_Catalog:nil];
    [self setBtn_AddImg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)click_PubPost:(id)sender {
    //发布文章
//    [self pubPost];
    [self pubPostWithImgs];
//    [self pubPost3];
    
}

#pragma 关闭键盘
-(IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}
-(IBAction)backgroundTap:(id)sender
{
    [txt_Body resignFirstResponder];
    [txt_Tags resignFirstResponder];
    [txt_Title resignFirstResponder];
}

- (IBAction)click_InsertImg:(id)sender {

    ImagesView *imgs = [ImagesView new];
    [self presentModalViewController:imgs animated:YES];
}

- (IBAction)click_PostList:(id)sender {
    
    UITabBarController *parent = (UITabBarController *)[self parentViewController];
    if (parent != nil) {
        
        parent.selectedIndex = 0;
    }
}


-(void)pubPostWithImgs
{
    if ([txt_Title.text isEqualToString:@""] || [txt_Body.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布失败" message:@"请确保填写了文章标题与内容" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    alertPubPost = [Tool getLoadingView:@"载入中" andMessage:@"正在发表文章,请耐心等待"];
    [alertPubPost show];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    [dict setValue:[NSString stringWithFormat:@"%d",catalogID] forKey:@"catalog"];
    [dict setValue:txt_Title.text forKey:@"title"];
    [dict setValue:txt_Body.text forKey:@"body"];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [request setHTTPShouldHandleCookies:YES];
    [request setValue:[Config.Instance http_user_agent] forHTTPHeaderField:@"User_Agent"];
    [request setHTTPMethod:@"POST"];
    NSURL *url= [NSURL URLWithString:Config.Instance.api_PostPub];
    [request setURL:url];
    //是否需要cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:[Config.Instance getCookieEntity]];
    //填充普通参数
    [request setValue:@"multipart/form-data;boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
    //post body
    NSMutableData *body = [NSMutableData data];
    //增加参数
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@", @"AaB03x"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n", @"title"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",txt_Title.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@", @"AaB03x"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n", @"catalog"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[NSString stringWithFormat:@"%d", catalogID]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@", @"AaB03x"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n", @"body"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",txt_Body.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@", @"AaB03x"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\nContent-Disposition:form-data;name=\"%@\"\r\n\r\n", @"tag"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",txt_Tags.text] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //先换行
//    [body appendData:[@"--AaB03x\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //增加图片
    
    if (DataSingleton.Instance.imgs != nil) {
        for (int i=0; i<[DataSingleton.Instance.imgs count]; i++) {
            NSData *imgData = UIImagePNGRepresentation([DataSingleton.Instance.imgs objectAtIndex:i]);
            [body appendData:[[NSString stringWithFormat:@"\r\n--AaB03x\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"img%d\";filename=\"img%d.png\"\r\n",i,i] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type:image/x-png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imgData];
        }
    }
    
    
    //结尾
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", @"AaB03x"] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    receivedPubPost = [[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedPubPost appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (alertPubPost) {
        [alertPubPost dismissWithClickedButtonIndex:0 animated:YES];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (receivedPubPost) {
        Xml_ApiError *x = [[Xml_ApiError alloc] initWithData:receivedPubPost];
        [x setDelegate:x];
        [x parse];
        if (x.error.errorCode > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发表成功" message:@"文章发表成功" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            //显示
            [alert show];
        }
        else
        {
            switch (x.error.errorCode) {
                case 0:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发表失败" message:@"用户未登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                    [alert show];
                }
                    break;
                case -2:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发表失败" message:@"没有删除权限" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
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
}
- (IBAction)click_ChoseCatalog:(id)sender {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择文章分类" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"返回"
        otherButtonTitles:nil, nil];
    for (int i=0; i<[DataSingleton.Instance.catalogs count]; i++) 
    {
        Catalog *c = (Catalog *)[DataSingleton.Instance.catalogs objectAtIndex:i];
        [sheet addButtonWithTitle:c.name];
    }
    //显示
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取点击按钮的标题
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    //登录处理
    if([buttonTitle isEqualToString:@"登录"]){
        //进入登录页
        UITabBarController *tabs = [self parentViewController];
        tabs.selectedIndex = 3;
        return;
    }
    else if ([buttonTitle isEqualToString:@"返回"]) {
        return;
    }
    Catalog *newCatalog = [DataProvider getCatalog:DataSingleton.Instance.catalogs byName:buttonTitle];
    if (newCatalog == nil) 
    {
        newCatalog = [DataSingleton.Instance.catalogs objectAtIndex:0];
    }
    self.lbl_Catalog.text = newCatalog.name;
//    self.lbl_Catalog.text = [NSString stringWithFormat:@"%@ %@ %@",newCatalog.name, newCatalog.name, newCatalog.name];
    catalogID = newCatalog._id;
}

#pragma 调整输入框
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-150, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+150, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    return YES;
}
@end
