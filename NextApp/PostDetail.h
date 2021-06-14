//
//  PostDetail.h
//  NextApp
//
//  Created by wangjun on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RelativePost.h"

@interface PostDetail : NSObject
{
    int _id;
    NSString *title;
    NSString *url;
    NSString *body;
    NSString *author;
    NSString *pubDate;
    int commentCount;
    NSMutableArray *relativePosts;
}

-(id)initWith:(int)newId andTitle:(NSString *)newTitle andUrl:(NSString *)newUrl andBody:(NSString *)newBody andAuthor:(NSString *)newAuthor andPubDate:(NSString *)newPubDate andCommentCount:(int)newCommentCount andRelativePosts:(NSMutableArray *)newRelativePosts;

@property int _id;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) NSString *body;
@property (nonatomic,retain) NSString *author;
@property (nonatomic,retain) NSString *pubDate;
@property int commentCount;
@property (nonatomic,retain) NSMutableArray *relativePosts;

@end
