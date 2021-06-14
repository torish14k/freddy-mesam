//
//  Single.m
//  NextApp
//
//  Created by wangjun on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Single.h"

@implementation Single
@synthesize segments;

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
    [self initControls];
}

-(void)initControls
{
    UIBarButtonItem *btn_ViewInSafari = [[UIBarButtonItem alloc] initWithTitle:@"用Safari浏览" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.rightBarButtonItem = btn_ViewInSafari;
    [btn_ViewInSafari setAction:@selector(click_ViewInSafari)];
    
    singlePost = [[SinglePost alloc] init];
    comments = [[Comments alloc] init];
    comments.isBelongToOnePost = YES;
    relativePosts = [[RelativePosts alloc] init];
    commentPub = [[CommentPub alloc] init];
    [commentPub initControls];
    
    //挂接引用
    singlePost.relativePosts = relativePosts;
    relativePosts.singlePost = singlePost;
    relativePosts.comments = comments;
    relativePosts.parent = self;
  
    self.title = @"文章详情";
    comments.view.hidden = YES;
    relativePosts.view.hidden = YES;
    commentPub.view.hidden = YES;

    [self.view addSubview:singlePost.view];
    [self.view addSubview:comments.view];
    [self.view addSubview:relativePosts.view];
    [self.view addSubview:commentPub.view];
}
-(void)click_ViewInSafari
{
    if (self.navigationItem.rightBarButtonItem.title == @"发表评论") {
        [commentPub click_CommentPub:nil];
    }
    else
    {
        if (DataSingleton.Instance.postToShare != nil) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DataSingleton.Instance.postToShare.url]];
        }
        else{
            return;
        }
    }
}
- (IBAction)segementSelectedIndexChanged:(id)sender {
    
    switch (segments.selectedSegmentIndex) {
        case 0:
            self.navigationItem.rightBarButtonItem.title = @"用Safari浏览";
            singlePost.view.hidden = NO;
            self.title = @"文章详情";
            comments.view.hidden = YES;
            relativePosts.view.hidden = YES;
            commentPub.view.hidden = YES;
            break;
        case 1:
            self.navigationItem.rightBarButtonItem.title = @"用Safari浏览";
            singlePost.view.hidden = YES;
            comments.view.hidden = NO;
            self.title = @"评论列表";
            relativePosts.view.hidden = YES;
            commentPub.view.hidden = YES;
            break;
        case 2:
            self.navigationItem.rightBarButtonItem.title = @"用Safari浏览";
            [relativePosts reload];
            singlePost.view.hidden = YES;
            comments.view.hidden = YES;
            relativePosts.view.hidden = NO;
            self.title = @"相关文章";
            commentPub.view.hidden = YES;
            break;
        case 3:
        {
            singlePost.view.hidden = YES;
            comments.view.hidden = YES;
            relativePosts.view.hidden = YES;
            commentPub.view.hidden = NO;
            [commentPub initTextFields];
            [commentPub initControls];
            self.title = @"发表评论";
            
            self.navigationItem.rightBarButtonItem.title = @"发表评论";
        }
            break;
        case 4:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享这篇文章到微博" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"返回" otherButtonTitles:@"新浪微博",@"腾讯微博", nil];
            [sheet showInView:self.view];
            self.segments.selectedSegmentIndex = lastSegementIndex;
        }
            break;
    }
    //更新 index
    lastSegementIndex = segments.selectedSegmentIndex;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取点击按钮的标题
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"新浪微博"]) {
        
        [self sinaShare];
    }
    else if([buttonTitle isEqualToString:@"腾讯微博"])
    {
        [self qqShare];
    }
}

-(void)sinaShare
{
    PostDetail *p = DataSingleton.Instance.postToShare;
    if (p == nil) {
        return;
    }
    if (!_engine){
		_engine = [[OAuthEngine alloc] initOAuthWithDelegate: self];
		_engine.consumerKey = SinaAppKey;
		_engine.consumerSecret = SinaAppSecret;
	}
    UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	//展示登录框
	if (controller) 
		[self presentModalViewController: controller animated: YES];
	else {
        
        progressView = [Tool getLoadingView:@"载入中" andMessage:@"正在发表"];
        [progressView show];
        @try {
            //开始发表
            [OAuthEngine setCurrentOAuthEngine:_engine];
            /*
             按照这种写法 已经没有方法签名的错误 但是还有其他未发现的内部错误          BAD_Access
             */
            
            WeiboClient *client = [WeiboClient new];
            [client initWithTarget:self engine:[OAuthEngine currentOAuthEngine] action:@selector(postStatusDidSucceed:obj:)];          
            NSString *text = [NSString stringWithFormat:@"%@ %@",p.title == nil ? @"" : p.title, p.url == nil ? @"" : p.url];
            /*
             注意所有的bug 都是在post这个方法中出现的
             */
            [client post:text];
        }
        @catch (NSException *exception) {
//            NSLog(@"分享到新浪微博错误: %@", [exception reason]);
        }
        @finally {
            if (progressView != nil) {
                [progressView dismissWithClickedButtonIndex:0 animated:YES];
            }
        }
    }
}

- (void)postStatusDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;
{
    if (progressView != nil) {
        [progressView dismissWithClickedButtonIndex:0 animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功分享" message:@"成功分享到新浪微博" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)qqShare
{
    [self qqShare_Web];
}

-(void)qqShare_Web
{
    PostDetail *p = DataSingleton.Instance.postToShare;
    
    NSString *share_url = @"http://share.v.t.qq.com/index.php?c=share&a=index";
    NSString *share_Source = @"NextApp";
    NSString *share_Site = @"nextapp.cn";
    NSString *share_AppKey = @"801080291";
    
    NSString *all = [NSString stringWithFormat:@"%@&title=%@&url=%@&appkey=%@&source=%@&site=%@", 
                     share_url,
                     [p.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     [p.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                     share_AppKey,
                     share_Source,
                     share_Site];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:all]];
}

- (void)viewDidUnload
{
    [self setSegments:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//=============================================================================================================================
#pragma mark OAuthEngineDelegate
- (void) storeCachedOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

- (void)removeCachedOAuthDataForUsername:(NSString *) username{
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults removeObjectForKey: @"authData"];
	[defaults synchronize];
}
//=============================================================================================================================
#pragma mark OAuthSinaWeiboControllerDelegate
- (void) OAuthController: (OAuthController *) controller authenticatedWithUsername: (NSString *) username {
//	NSLog(@"Authenicated for %@", username);
//	[self loadTimeline];
    [self sinaShare];
}

- (void) OAuthControllerFailed: (OAuthController *) controller {
//	NSLog(@"Authentication Failed!");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
//	if (controller) 
//		[self presentModalViewController: controller animated: YES];
	
}

- (void) OAuthControllerCanceled: (OAuthController *) controller {
//	NSLog(@"Authentication Canceled.");
	//UIViewController *controller = [OAuthController controllerToEnterCredentialsWithEngine: _engine delegate: self];
	
	//if (controller) 
    //[self presentModalViewController: controller animated: YES];
	
}



@end
