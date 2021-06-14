//
//  ApiError.m
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ApiError.h"

@implementation ApiError

@synthesize errorCode;
@synthesize errorMessage;

-(id)initWith:(int)newErrorCode andErrorMessage:(NSString *)newErrorMessage
{
    self.errorCode = newErrorCode;
    self.errorMessage = newErrorMessage;
    return self;
}

@end
