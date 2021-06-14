//
//  Post.h
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject
{
    int _id;
    NSString * title;
    NSString * url;
    NSString * img;
    NSString * outline;
    int commentCount;
    NSString * author;
    NSString * authorId;
    NSMutableArray * catalog;
    NSString * pubDate;
    UIImage * imgData;
//    NSString * body;
//    NSMutableArray * tags;
//    NSMutableArray * relativePosts;
}

-(id)initWith:(int)newId 
         andTitle:(NSString *)newTitle
         andUrl:(NSString *)newUrl
         andOutline:(NSString *)newOutline
andCommentCount:(int)newCommentCount
andAuthor:(NSString *)newAuthor
andAuthorId:(NSString *)newAuthorId
andCatalogs:(NSMutableArray *)newCatalogs
andPubDate:(NSString *)newPubDate
andBody:(NSString *)newBody
andTags:(NSMutableArray *)newTags
andRelativePosts:(NSMutableArray *)newRelativePosts;

@property int _id;
@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) NSString * url;
@property (nonatomic,retain) NSString * img;
@property (nonatomic,retain) NSString * outline;
@property int commentCount;
@property (nonatomic,retain) NSString * authorId;
@property (nonatomic,retain) NSString * author;
@property (nonatomic,retain) NSMutableArray * catalog;
@property (nonatomic,retain) NSString * pubDate;
@property (nonatomic,retain) UIImage * imgData;
//@property (nonatomic,retain) NSString * body;
//@property (nonatomic,retain) NSMutableArray * tags;
//@property (nonatomic,retain) NSMutableArray * relativePosts;

@end
