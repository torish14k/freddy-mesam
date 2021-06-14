//
//  CommentDelete.h
//  NextApp
//
//  Created by wangjun on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Xml_ApiError.h"
#import "Tool.h"
#import "Comments.h"
@class Comments;

@interface CommentDelete : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableData *receivedData;
    UIAlertView *alertView;
    
    Comments *parent;
}

-(void)deleteComment:(int)_id;
@property (nonatomic,retain) Comments *parent;

+(CommentDelete *) Instance;
+(id)allocWithZone:(NSZone *)zone;

@end
