//
//  Xml_ApiError.h
//  NextApp
//
//  Created by wangjun on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiError.h"

@interface Xml_ApiError : NSXMLParser<NSXMLParserDelegate>
{
    ApiError *error;
    
    BOOL berrorCode;
    BOOL berrorMessage;
}

@property (retain,nonatomic) ApiError *error;

@end
