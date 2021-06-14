//
//  Comment.h
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
{
    int _id;
    int post;
    NSString * name;
    NSString * email;
    NSString * url;
    NSString * body;
    NSString * pubDate;
}

-(id)initWith: (int)newId andPostID:(int)newPostId 
andName:(NSString *)newName andEmail:(NSString *)newEmail
andUrl:(NSString *)newUrl andBody:(NSString *)newBody 
andPubDate:(NSString *)newPubDate;

@property int _id;
@property int post;
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * email;
@property (nonatomic,retain) NSString * url;
@property (nonatomic,retain) NSString * body;
@property (nonatomic,retain) NSString * pubDate;

@end
