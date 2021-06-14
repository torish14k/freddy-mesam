//
//  CommentsList.m
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CommentsList.h"

@implementation CommentsList

@synthesize commentCount;
@synthesize comments;

-(id)initWith:(int)newCommentCount andComments:(NSMutableArray *)newComments
{
    self.commentCount = newCommentCount;
    self.comments = newComments;
    return  self;
}

@end
