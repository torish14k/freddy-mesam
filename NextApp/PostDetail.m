//
//  PostDetail.m
//  NextApp
//
//  Created by wangjun on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostDetail.h"

@implementation PostDetail

@synthesize _id;
@synthesize title;
@synthesize url;
@synthesize body;
@synthesize author;
@synthesize pubDate;
@synthesize commentCount;
@synthesize relativePosts;

-(id)initWith:(int)newId andTitle:(NSString *)newTitle andUrl:(NSString *)newUrl andBody:(NSString *)newBody andAuthor:(NSString *)newAuthor andPubDate:(NSString *)newPubDate andCommentCount:(int)newCommentCount andRelativePosts:(NSMutableArray *)newRelativePosts
{
    self._id = newId;
    self.title = newTitle;
    self.url = newUrl;
    self.body = newBody;
    self.author = newAuthor;
    self.pubDate = newPubDate;
    self.commentCount = newCommentCount;
    self.relativePosts = newRelativePosts;
    
    return self;
};

@end
