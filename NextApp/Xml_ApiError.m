//
//  Xml_ApiError.m
//  NextApp
//
//  Created by wangjun on 12-1-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Xml_ApiError.h"

@implementation Xml_ApiError

@synthesize error;

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    error = [ApiError new];
//    error.errorCode = -100;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"errorCode"]) {
        berrorCode = YES;
    }
    else if([elementName isEqualToString:@"errorMessage"]){
        berrorMessage = YES;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (berrorCode /*&& error.errorCode == -100*/) 
    {
        error.errorCode = [string intValue];
        berrorCode = NO;
    }
    else if(berrorMessage && error.errorMessage == nil){
        error.errorMessage = string;
        berrorMessage = NO;
    }
}


@end
