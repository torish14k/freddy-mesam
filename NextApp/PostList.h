//
//  PostList.h
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostList : NSObject
{
    int catalog;
    int postCount;
    NSMutableArray * posts;
}

-(id)initWith:(int)newCatalog andPostCount:(int)newPostCount andPosts:(NSMutableArray *)newPosts;

@property int catalog;
@property int postCount;
@property (nonatomic,retain) NSMutableArray * posts;

@end
