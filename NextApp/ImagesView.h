//
//  ImagesView.h
//  NextApp
//
//  Created by wangjun on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSingleton.h"

#define ImageCellIdentifier @"ImageCellIdentifier"

@interface ImagesView : UIViewController<UIImagePickerControllerDelegate,UITableViewDelegate,
    UITableViewDataSource>
{
}
-(IBAction)click_Close:(id)sender;
-(IBAction)click_ChoseImgs:(id)sender;

-(void)reload;
-(void)addMoreItem;

@end
