//
//  RelativePost.h
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RelativePost : NSObject
{
    int _id;
    NSString * title;
    NSString * author;
    NSString * pubDate;
}

-(id)initWith:(int)newId andTitle:(NSString *)newTitle
      andAuthor:(NSString *)newAuthor andPubDate:(NSString *)newPubDate;

@property int _id;
@property (nonatomic,retain) NSString * title;
@property (nonatomic,retain) NSString * author;
@property (nonatomic,retain) NSString * pubDate;

@end
