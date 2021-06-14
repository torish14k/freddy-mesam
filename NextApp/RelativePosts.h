//
//  RelativePosts.h
//  NextApp
//
//  Created by wangjun on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "PostDetail.h"
#import "DataSingleton.h"
#import "DataProvider.h"
#import "RelativePostCell.h"
#import "RelativePost.h"
#import "Tool.h"
#import "Xml_ApiError.h"
#import "Single.h"
@class SinglePost;
@class Comments;
@class Single;

#define RelativePostCellIdentifier @"RelativePostCellIdentifier"

@interface RelativePosts : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDataDelegate>
{
    Single *parent;
    SinglePost *singlePost;
    Comments *comments;
    
    NSMutableData *receivedDelPost;
    UIAlertView *alertDelPost;
}

@property (retain,nonatomic) SinglePost *singlePost;
@property (retain,nonatomic) Comments *comments;
@property (retain,nonatomic) Single *parent;

@property (strong, nonatomic) IBOutlet UITableView *tableRelativePosts;
//删除文章
-(void)delPost:(int)_id;
//重新载入
-(void)reload;

@end
