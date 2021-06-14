//
//  Xml_Comments.h
//  NextApp
//
//  Created by wangjun on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comment.h"
#import "CommentsList.h"

@interface Xml_Comments : NSXMLParser<NSXMLParserDelegate>
{
    CommentsList *commentsList;
    Comment *comment;
    
    BOOL bcommentCount;
    BOOL bid;
    BOOL bpost;
    BOOL bname;
    BOOL bbody;
    BOOL bpubDate;
}

@property (nonatomic,retain) CommentsList *commentsList;

@end
