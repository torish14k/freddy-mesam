//
//  RelativePost.m
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RelativePost.h"

@implementation RelativePost

@synthesize _id;
@synthesize title;
@synthesize author;
@synthesize pubDate;

-(id)initWith:(int)newId andTitle:(NSString *)newTitle andAuthor:(NSString *)newAuthor andPubDate:(NSString *)newPubDate
{
    self._id = newId;
    self.title = newTitle;
    self.author = newAuthor;
    self.pubDate = newPubDate;
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@  %@  %@  %@", self._id, self.title, self.author, self.pubDate];
}

@end
