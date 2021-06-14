//
//  Xml_PostDetail.h
//  NextApp
//
//  Created by wangjun on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostDetail.h"
#import "RelativePost.h"

@interface Xml_PostDetail : NSXMLParser<NSXMLParserDelegate>
{
    PostDetail *postDetail;
    RelativePost *relative;
    
    BOOL bid;
    BOOL btitle;
    BOOL burl;
    BOOL bbody;
    BOOL bauthor;
    BOOL bpubDate;
    BOOL bcommentCount;
    
    BOOL bRelative;
    BOOL bRelative_id;
    BOOL bRelative_title;
    BOOL bRelative_author;
    BOOL bRelative_pubDate;
}

@property (retain,nonatomic) PostDetail *postDetail;

@end
