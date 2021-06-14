//
//  Xml_PostDetail.m
//  NextApp
//
//  Created by wangjun on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Xml_PostDetail.h"

@implementation Xml_PostDetail

@synthesize postDetail;

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    postDetail = [PostDetail new];
    //此句绝对不可少
    postDetail.relativePosts = [[NSMutableArray alloc] initWithCapacity:20];
    relative = [RelativePost new];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"relativePosts"]) {
        bRelative = YES;
    }
    
    if (!bRelative) {
        if ([elementName isEqualToString:@"id"])
            bid = YES;
        else if([elementName isEqualToString:@"title"])
            btitle = YES;
        else if([elementName isEqualToString:@"url"])
            burl = YES;
        else if([elementName isEqualToString:@"body"])
            bbody = YES;
        else if([elementName isEqualToString:@"author"])
            bauthor = YES;
        else if([elementName isEqualToString:@"pubDate"])
            bpubDate = YES;
        else if([elementName isEqualToString:@"commentCount"])
            bcommentCount = YES;
        else if([elementName isEqualToString:@"relativePosts"])
            bRelative = YES;
    }
    else
    {
        if ([elementName isEqualToString:@"id"]) 
            bRelative_id = YES;
        else if([elementName isEqualToString:@"title"])
            bRelative_title = YES;
        else if([elementName isEqualToString:@"author"])
            bRelative_author = YES;
        else if([elementName isEqualToString:@"pubDate"])
            bRelative_pubDate = YES;
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!bRelative) {
        if (bid && postDetail._id == 0) {
            postDetail._id = [string intValue];
            bid = NO;
        }
        else if(btitle && postDetail.title == nil){
            postDetail.title = string;
            btitle = NO;
        }
        else if(burl && postDetail.url == nil){
            postDetail.url = string;
            burl = NO;
        }
        else if(bbody && postDetail.body == nil){
            postDetail.body = string;
            bbody = NO;
        }
        else if(bauthor && postDetail.author == nil){
            postDetail.author = string;
            bauthor = NO;
        }
        else if(bpubDate && postDetail.pubDate == nil){
            postDetail.pubDate = string;
            bpubDate = NO;
        }
        else if(bcommentCount && postDetail.commentCount == 0){
            postDetail.commentCount = [string intValue];
            bcommentCount = NO;
        }
    }
    else 
    {
        if (bRelative_id && relative._id == 0) {
            relative._id = [string intValue];
            bRelative_id = NO;
        }
        else if(bRelative_title && relative.title == nil){
            relative.title = string;
            bRelative_title = NO;
        }
        else if(bRelative_author && relative.author == nil){
            relative.author = string;
            bRelative_author = NO;
        }
        else if(bRelative_pubDate && relative.pubDate == nil){
            relative.pubDate = string;
            bRelative_pubDate = NO;
        }
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"relativePost"]) {
        
        [postDetail.relativePosts addObject:relative];
        relative = [RelativePost new];
    }
}

@end
