//
//  SinglePost.h
//  NextApp
//
//  Created by wangjun on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataProvider.h"
#import "DataSingleton.h"
#import "Tool.h"
#import "Xml_PostDetail.h"
#import "RegexKitLite.h"
#import "Config.h"

@class RelativePosts;

@interface SinglePost : UIViewController<NSURLConnectionDataDelegate>
{
    RelativePosts *relativePosts;
    
    NSMutableData *receivedPostDetail;
    UIAlertView *alertPostDetail;
}

@property (retain, nonatomic) RelativePosts *relativePosts;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Title;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Author;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PubDate;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
//加载文章
-(void)initControls;
-(void)initPostDetail;
-(NSString *)processHTML:(NSString *)source;

@property (strong, nonatomic) IBOutlet UILabel *fixedLabel_Author;

@end
