//
//  Catalog.m
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Catalog.h"

@implementation Catalog

@synthesize _id;
@synthesize name;
@synthesize description;
@synthesize postCount;

-(id)initWith:(int)newId andName:(NSString *)newName andDescription:(NSString *)newDescription andPostCount:(int)newPostCount
{
    self._id = newId;
    self.name = newName;
    self.description = newDescription;
    self.postCount = newPostCount;
    return self;
}


@end
