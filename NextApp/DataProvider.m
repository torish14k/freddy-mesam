//
//  DataProvider.m
//  NextApp
//
//  Created by wangjun on 12-1-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataProvider.h"

@implementation DataProvider

+(Post *)getPost:(NSMutableArray *)posts byID:(int)postID
{
    Post *p;
    for (int i=0; i<[posts count]; i++) 
    {
        p = (Post *)[posts objectAtIndex:i];
        if (p != nil && p._id == postID) {
            return p;
        }
    }
    return  nil;
}

+(Comment *)getComment:(NSMutableArray *)comments byID:(int)commentID
{
    Comment *c;
    for (int i=0; i<[comments count]; i++) 
    {
        c = (Comment *)[comments objectAtIndex:i];
        if (c != nil && c._id == commentID) {
            return c;
        }
    }
    return nil;
}

+(Catalog *)getCatalog:(NSMutableArray *)catalogs byName:(NSString *)cName
{
    Catalog *c;
    for (int i=0; i<[catalogs count]; i++) {
        c = (Catalog *)[catalogs objectAtIndex:i];
        if (c != nil && [c.name isEqualToString:cName] ) {
            return c;
        }
    }
    return nil;
}

+(BOOL)isRepeatPost:(NSMutableArray *)oldPosts byID:(int)postID
{
    for (Post *p in oldPosts) {
        if (p._id == postID) {
            return YES;
        }
    }
    return NO;
}

+(BOOL)isRepeatComment:(NSMutableArray *)oldComments byID:(int)commentID
{
    for (Comment *c in oldComments) {
        if (c._id == commentID) {
            return YES;
        }
    }
    return NO;
}

@end
