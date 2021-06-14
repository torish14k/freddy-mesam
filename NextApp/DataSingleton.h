//
//  DataSingleton.h
//  NextApp
//
//  Created by wangjun on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "Catalog.h"
#import "Comment.h"
#import "Config.h"
#import "PostDetail.h"

@interface DataSingleton : NSObject
{
    NSMutableArray * catalogs;
    //单项数据 很重要
    PostDetail * postToShare;
    //表示当前需要显示的文章分类
    Catalog * currentCatalog;
    //表示发表文章时上传的图片
    NSMutableArray *imgs;
}

@property (nonatomic,retain) NSMutableArray * catalogs;
@property (nonatomic,retain) PostDetail * postToShare;
@property (nonatomic,retain) Catalog * currentCatalog;
@property (nonatomic,retain) NSMutableArray *imgs;

+(DataSingleton *) Instance;
+(id)allocWithZone:(NSZone *)zone;
//初始化测试方法
-(void)initialize;

@end
