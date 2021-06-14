//
//  Post.m
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize _id;
@synthesize title;
@synthesize url;
@synthesize img;
@synthesize outline;
@synthesize commentCount;
@synthesize author;
@synthesize authorId;
@synthesize catalog;
@synthesize pubDate;
@synthesize imgData;
//@synthesize body;
//@synthesize tags;
//@synthesize relativePosts;

-(id)initWith:(int)newId andTitle:(NSString *)newTitle andUrl:(NSString *)newUrl andOutline:(NSString *)newOutline andCommentCount:(int)newCommentCount andAuthor:(NSString *)newAuthor andAuthorId:(NSString *)newAuthorId andCatalogs:(NSMutableArray *)newCatalogs andPubDate:(NSString *)newPubDate andBody:(NSString *)newBody andTags:(NSMutableArray *)newTags andRelativePosts:(NSMutableArray *)newRelativePosts
{
    self._id = newId;
    self.title = newTitle;
    self.url = newUrl;
    self.outline = newOutline;
    self.commentCount = newCommentCount;
    self.author = newAuthor;
    self.authorId = newAuthorId;
    self.catalog = newCatalogs;
    self.pubDate = newPubDate;
//    self.body = newBody;
//    self.tags = newTags;
//    self.relativePosts = newRelativePosts;
    return self;
}


@end
