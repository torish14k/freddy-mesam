//
//  Comments.h
//  NextApp
//
//  Created by wangjun on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "Tool.h"
#import "CommentCell.h"
#import "DataProvider.h"
#import "DataSingleton.h"
#import "PostDetail.h"
#import "Xml_Comments.h"
#import "Config.h"
#import "Xml_ApiError.h"
@class Single;
#import "SinglePost.h"
#import "Single.h"
#import "CommentDelete.h"

/*
 我们需要明白一个问题:
 这个CommentsView 我们只需要加载 post = 0 就行 即读取所有的评论
 */
#define MaxCount_ReloadComments 10

#define CommentCellIdentifier @"CommentCellIdentifier"

@interface Comments : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate>
{
    NSMutableArray *comments;
    //很重要  代表本 View 是显示某一个Post的还是全部的评论
    BOOL isBelongToOnePost;
    BOOL isLoadOver;
    BOOL isLoadOnce;
    
    NSMutableData *receivedComments;
    UIAlertView *alertComments;
}
@property (strong, nonatomic) IBOutlet UITableView *tableComments;
@property BOOL isBelongToOnePost;

-(void)initControls;
-(void)reloadComments;
-(void)reloadComments4ChangePost;
-(void)delComment:(int)_id;

@property (nonatomic,retain) NSMutableArray *comments;

-(IBAction)btn_ReloadComments_Click:(id)sender;

@end
