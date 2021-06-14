//
//  Xml_GetApis.h
//  NextApp
//
//  Created by wangjun on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Xml_GetApis : NSXMLParser<NSXMLParserDelegate>
{
    //Api信息
    NSString * version;
    NSString * api_Catalogs;
    NSString * api_Posts;
    NSString * api_PostDetail;
    NSString * api_PostPub;
    NSString * api_PostDel;
    NSString * api_Comments;
    NSString * api_CommentPub;
    NSString * api_CommentDel;
    NSString * api_LoginValidate;
    
    BOOL bVersion;
    BOOL bCatalogs;
    BOOL bPosts;
    BOOL bPostDetail;
    BOOL bPostPub;
    BOOL bPostDel;
    BOOL bComments;
    BOOL bCommentPub;
    BOOL bCommentDel;
    BOOL bLoginValidate;
}
@property (retain,nonatomic) NSString *version;
@property (retain,nonatomic) NSString *api_Catalogs;
@property (retain,nonatomic) NSString *api_Posts;
@property (retain,nonatomic) NSString *api_PostDetail;
@property (retain,nonatomic) NSString *api_PostPub;
@property (retain,nonatomic) NSString *api_PostDel;
@property (retain,nonatomic) NSString *api_Comments;
@property (retain,nonatomic) NSString *api_CommentPub;
@property (retain,nonatomic) NSString *api_CommentDel;
@property (retain,nonatomic) NSString *api_LoginValidate;

@end
