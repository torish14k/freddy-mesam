//
//  Xml_Comments.m
//  NextApp
//
//  Created by wangjun on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Xml_Comments.h"

@implementation Xml_Comments

@synthesize commentsList;

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    commentsList = [CommentsList new];
    //此句必不可少 否则无法添加近来新数据
    commentsList.comments = [[NSMutableArray alloc] initWithCapacity:10];
    comment = [Comment new];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"commentCount"]) {
        bcommentCount = YES;
    }
    else if([elementName isEqual:@"id"]){
        bid = YES;
    }
    else if([elementName isEqual:@"post"]){
        bpost = YES;
    }
    else if([elementName isEqual:@"name"]){
        bname = YES;
    }
    else if([elementName isEqual:@"body"]){
        bbody = YES;
    }
    else if([elementName isEqual:@"pubDate"]){
        bpubDate = YES;
    }
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (bcommentCount && commentsList.commentCount == 0) {
        commentsList.commentCount = [string intValue];
        bcommentCount = NO;
    }
    else if(bid && comment._id == 0){
        comment._id = [string intValue];
        bid = NO;
    }
    else if(bpost && comment.post == 0){
        comment.post = [string intValue];
        bpost = NO;
    }
    else if(bname && comment.name == nil){
        comment.name = string;
        bname = NO;
    }
    else if(bbody && comment.body == nil){
        comment.body = string;
        bbody = NO;
    }
    else if(bpubDate && comment.pubDate == nil){
        comment.pubDate = string;
        bpubDate = NO;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"comment"]) {

        [commentsList.comments addObject:comment];
        comment = [Comment new];
    }
}

@end
