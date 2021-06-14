//
//  ApiError.h
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiError : NSObject
{
    int errorCode;
    NSString * errorMessage;
}

-(id)initWith:(int)newErrorCode andErrorMessage:(NSString *)newErrorMessage;

@property int errorCode;
@property (nonatomic,retain) NSString * errorMessage;

@end
