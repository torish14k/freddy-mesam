//
//  Xml_Posts.h
//  NextApp
//
//  Created by wangjun on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "PostList.h"

@interface Xml_Posts : NSXMLParser<NSXMLParserDelegate>
{
    PostList *postList;
    Post *post;

    BOOL bcatalog;
    BOOL bpostCount;
    BOOL bid;
    BOOL btitle;
    BOOL bimg;
    BOOL boutline;
    BOOL bcommentCount;
    BOOL bauthor;
    BOOL bpubDate;
}

@property (retain,nonatomic) PostList *postList;

@end
