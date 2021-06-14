//
//  CommentsList.h
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsList : NSObject
{
    int commentCount;
    NSMutableArray * comments;
}

-(id)initWith:(int)newCommentCount andComments:(NSMutableArray *)newComments;

@property int commentCount;
@property (nonatomic,retain) NSMutableArray * comments;

@end
