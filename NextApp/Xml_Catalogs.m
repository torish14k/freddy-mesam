//
//  Xml_Catalogs.m
//  NextApp
//
//  Created by wangjun on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Xml_Catalogs.h"

@implementation Xml_Catalogs

@synthesize catalogs;

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    catalogs = [[NSMutableArray alloc] initWithCapacity:20];
}
//开始遍历
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqual:@"catalog"]) {
        NSString *name = [attributeDict objectForKey:@"name"];
        NSString *description = [attributeDict objectForKey:@"description"];
        int _id = [[attributeDict objectForKey:@"id"] intValue];
        int postCount = [[attributeDict objectForKey:@"postCount"] intValue];
        
        item = [[Catalog alloc] initWith:_id andName:name andDescription:description andPostCount:postCount];
    }

}
//遍历到了节点末尾
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqual:@"catalog"]) {
        [catalogs addObject:item];
    }
}

@end
