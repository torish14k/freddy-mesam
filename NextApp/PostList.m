//
//  PostList.m
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PostList.h"

@implementation PostList

@synthesize catalog;
@synthesize postCount;
@synthesize posts;

-(id)initWith:(int)newCatalog andPostCount:(int)newPostCount andPosts:(NSMutableArray *)newPosts
{
    self.catalog = newCatalog;
    self.postCount = newPostCount;
    self.posts = newPosts;
    return self;
}

@end
