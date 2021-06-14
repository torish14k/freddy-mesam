//
//  Xml_Posts.m
//  NextApp
//
//  Created by wangjun on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Xml_Posts.h"


@implementation Xml_Posts

@synthesize postList;

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    postList = [PostList new];
    //此举必不可少 否则无法添加数据进去
    postList.posts = [[NSMutableArray alloc] initWithCapacity:5];
    post = [Post new];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"catalog"]) 
        bcatalog = YES;
    else if([elementName isEqual:@"postCount"])
        bpostCount = YES;
    else if([elementName isEqual:@"img"])
        bimg = YES;
    else if([elementName isEqual:@"id"])
        bid = YES;
    else if([elementName isEqual:@"title"])
        btitle = YES;
    else if([elementName isEqual:@"outline"])
        boutline = YES;
    else if([elementName isEqual:@"commentCount"])
        bcommentCount = YES;
    else if([elementName isEqual:@"author"])
        bauthor = YES;
    else if([elementName isEqual:@"pubDate"])
        bpubDate = YES;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (bcatalog && postList.catalog == 0) {
        postList.catalog = [string intValue];
        bcatalog = NO;
    }
    else if(bpostCount && postList.postCount == 0){
        postList.postCount = [string intValue];
        bpostCount = NO;
    }
    else if(bid && post._id == 0){
        post._id = [string intValue];
        bid = NO;
    }
    else if(btitle && post.title == nil){
        post.title = string;
        btitle = NO;
    }
    else if(bimg && post.img == nil){

        if([string length] > 8)
            post.img = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        bimg = NO;
    }
    else if(boutline && post.outline == nil){
        post.outline = string;
        boutline = NO;
    }
    else if(bcommentCount && post.commentCount == 0){
        post.commentCount = [string intValue];
        bcommentCount = NO;
    }
    else if(bauthor && post.author == nil){
        post.author = string;
        bauthor = NO;
    }
    else if(bpubDate && post.pubDate == nil){
        post.pubDate = string;
        bpubDate = NO;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"post"]) {
        
        [postList.posts addObject:post];
        post = [Post new];
    }
}

@end
