//
//  About.h
//  NextApp
//
//  Created by wangjun on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface About : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *txt_SiteTitle;
@property (strong, nonatomic) IBOutlet UITextView *txt_SiteDescription;
@property (strong, nonatomic) IBOutlet UITextView *txt_SiteUrl;


@end
