//
//  Xml_GetApis.m
//  NextApp
//
//  Created by wangjun on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Xml_GetApis.h"

@implementation Xml_GetApis

@synthesize version;
@synthesize api_Posts;
@synthesize api_Catalogs;
@synthesize api_PostDetail;
@synthesize api_PostPub;
@synthesize api_PostDel;
@synthesize api_Comments;
@synthesize api_CommentDel;
@synthesize api_CommentPub;
@synthesize api_LoginValidate;

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"version"]) 
        bVersion = YES;
    else if([elementName isEqualToString:@"catalog-list"])
        bCatalogs = YES;
    else if([elementName isEqualToString:@"post-list"])
        bPosts = YES;
    else if([elementName isEqualToString:@"post-detail"])
        bPostDetail = YES;
    else if([elementName isEqualToString:@"post-pub"])
        bPostPub = YES;
    else if([elementName isEqualToString:@"post-delete"])
        bPostDel = YES;
    else if([elementName isEqualToString:@"comment-list"])
        bComments = YES;
    else if([elementName isEqualToString:@"comment-pub"])
        bCommentPub = YES;
    else if([elementName isEqualToString:@"comment-delete"])
        bCommentDel = YES;
    else if([elementName isEqualToString:@"login-validate"])
        bLoginValidate = YES;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (bVersion && version == nil) {
        version = string;
        bVersion = NO;
    }
    else if(bCatalogs && api_Catalogs == nil){
        api_Catalogs = string;
        bCatalogs = NO;
    }
    else if(bPosts && api_Posts == nil){
        api_Posts = string;
        bPosts = NO;
    }
    else if(bPostDetail && api_PostDetail == nil){
        api_PostDetail = string;
        bPostDetail = NO;
    }
    else if(bPostPub && api_PostPub == nil){
        api_PostPub = string;
        bPostPub = NO;
    }
    else if(bPostDel && api_PostDel == nil){
        api_PostDel = string;
        bPostDel = NO;
    }
    else if(bComments && api_Comments == nil){
        api_Comments = string;
        bComments = NO;
    }
    else if(bCommentPub && api_CommentPub == nil){
        api_CommentPub = string;
        bCommentPub = NO;
    }
    else if(bCommentDel && api_CommentDel == nil){
        api_CommentDel = string;
        bCommentDel = NO;
    }
    else if(bLoginValidate && api_LoginValidate == nil){
        api_LoginValidate = string;
        bLoginValidate = NO;
    }
}

@end























