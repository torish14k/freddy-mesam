//
//  Xml_Catalogs.h
//  NextApp
//
//  Created by wangjun on 12-1-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Catalog.h"

@interface Xml_Catalogs : NSXMLParser<NSXMLParserDelegate>
{
    NSMutableArray *catalogs;
    Catalog *item;
}

@property (nonatomic,retain) NSMutableArray *catalogs;

@end
