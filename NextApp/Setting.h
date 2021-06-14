//
//  Setting.h
//  NextApp
//
//  Created by wangjun on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface Setting : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *switchPostlistlayout;
- (IBAction)selectPostlistLayout:(id)sender;

@end
