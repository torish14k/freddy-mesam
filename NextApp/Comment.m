//
//  Comment.m
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize _id;
@synthesize post;
@synthesize name;
@synthesize email;
@synthesize url;
@synthesize body;
@synthesize pubDate;

-(id)initWith:(int)newId andPostID:(int)newPostId andName:(NSString *)newName andEmail:(NSString *)newEmail andUrl:(NSString *)newUrl andBody:(NSString *)newBody andPubDate:(NSString *)newPubDate
{
    self._id = newId;
    self.post = newPostId;
    self.name = newName;
    self.email = newEmail;
    self.url = newUrl;
    self.body = newBody;
    self.pubDate = newPubDate;
    return  self;
}


@end
