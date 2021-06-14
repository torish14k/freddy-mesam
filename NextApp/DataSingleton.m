//
//  DataSingleton.m
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DataSingleton.h"

@implementation DataSingleton

@synthesize catalogs;
@synthesize postToShare;
@synthesize currentCatalog;
@synthesize imgs;

-(void)initialize
{
    imgs = [[NSMutableArray alloc] initWithCapacity:20];
}


static DataSingleton * instance = nil;

+(DataSingleton *) Instance
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

@end
