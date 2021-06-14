//
//  PostDelete.h
//  NextApp
//
//  Created by wangjun on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"
#import "Xml_ApiError.h"
#import "Posts.h"
@class Posts;

@interface PostDelete : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData *receiveData;
    UIAlertView *alertView;
    
    Posts *parent;
}

-(void)deletePost:(int)_id;
@property (nonatomic,retain) Posts *parent;

+(PostDelete *) Instance;
+(id)allocWithZone:(NSZone *)zone;

@end
