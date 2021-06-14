//
//  Catalog.h
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Catalog : NSObject
{
    int _id;
    NSString * name;
    NSString * description;
    int postCount;
}

-(id) initWith:(int) newId 
       andName:(NSString *) newName 
       andDescription:(NSString *) newDescription
       andPostCount:(int)newPostCount;

@property int _id;
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * description;
@property int postCount;

@end
