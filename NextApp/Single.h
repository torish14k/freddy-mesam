//
//  Single.h
//  NextApp
//
//  Created by wangjun on 12-1-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinglePost.h"
#import "RelativePosts.h"
#import "Comments.h"
#import "CommentPub.h"
#import "OAuthEngine.h"
#import "WeiboClient.h"
#import "OAuthController.h"
#import "PostDetail.h"
#import "DataSingleton.h"
#import "Tool.h"

#import "QWeiboAsyncApi.h"
#import "QQShare.h"
#import "QVerifyWebViewController.h"
#import "QLoadingView.h"

#define SinaAppKey @"156524751"
#define SinaAppSecret @"b09a216632a74487884de5d16de8fb11"

#define QQApiKey @"801080291"
#define QQApiSceret @"3c1b59290717cf27185a38f6cd7acc49"

@class Comments;
@class RelativePosts;
@class SinglePost;
@class CommentPub;

@interface Single : UIViewController<OAuthControllerDelegate>
{
    SinglePost *singlePost;
    Comments *comments;
    RelativePosts *relativePosts; 
    CommentPub *commentPub;
    int lastSegementIndex;
    
    //新浪微博
    OAuthEngine	*_engine;
	WeiboClient *weiboClient;
    UIAlertView *progressView;
    
    //腾讯微博
    NSURLConnection *connection;
}
- (IBAction)segementSelectedIndexChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segments;

- (void)postStatusDidSucceed:(WeiboClient*)sender obj:(NSObject*)obj;

-(void)initControls;
-(void)sinaShare;
-(void)qqShare;
-(void)qqShare_Web;

@end
