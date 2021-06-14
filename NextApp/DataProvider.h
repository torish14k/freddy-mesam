//
//  DataProvider.h
//  NextApp
//
//  Created by wangjun on 12-1-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "Comment.h"
#import "Catalog.h"
#import "RelativePost.h"
#import "Catalog.h"

@interface DataProvider : NSObject

//获取文章
+(Post *)getPost:(NSMutableArray *)posts byID:(int)postID;
//获取评论
+(Comment *)getComment:(NSMutableArray *)comments byID:(int)commentID;
//获取文章分类
+(Catalog *)getCatalog:(NSMutableArray *)catalogs byName:(NSString *)cName;
//判断是否有重复的文章 没有重复才添加
+(BOOL)isRepeatPost:(NSMutableArray *)oldPosts byID:(int)postID;
//判断是否有重复的评论 没有重复才添加
+(BOOL)isRepeatComment:(NSMutableArray *)oldComments byID:(int)commentID;

@end
