//
//  Posts.h
//  NextApp
//
//  Created by wangjun on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Tool.h"
#import "PostCell.h"
#import "PostCellBig.h"
#import "PostCellTitle.h"
#import "SinglePost.h"
#import "Single.h"
#import "DataSingleton.h"
#import "Catalog.h"
#import "DataProvider.h"
#import "Xml_Posts.h"
#import "Xml_ApiError.h"
#import "PostDelete.h"
#import "Config.h"

#define MaxCount_ReloadPosts 5
#define PostCellIdentifier @"PostCellIdentifier"

@interface Posts : UIViewController<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate, NSURLConnectionDataDelegate>
{
    NSMutableArray *posts;
    BOOL isLoadOver;
    CGPoint _location;
    
    NSMutableData *receivedPosts;
    UIAlertView *alertPosts;
    
    int currentLayout;
    bool isInitialize;
}

@property (nonatomic,retain) NSMutableArray *posts;

-(IBAction)btn_Catalogs_Click:(id)sender;

-(IBAction)btn_ReloadPosts_Click:(id)sender;

//加载文章
-(void)initControls;
-(void)reloadPosts;
-(void)delPost:(int)_id;
@property (strong, nonatomic) IBOutlet UITableView *tablePosts;

-(void)initPostlistLayout;

@end
