//
//  main.m
//  NextApp
//
//  Created by wangjun on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BIDAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([BIDAppDelegate class]));
        }
        @catch (NSException *exception) {
//            NSLog(@"main方法中错误 %@",exception.reason);
        }
        @finally {
            return 1;
        }
    }   
}
