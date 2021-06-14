//
//  PostCellBig.h
//  NextApp
//
//  Created by wangjun on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCellBig : UITableViewCell

//长按删除元素用
@property (nonatomic,assign) id delegate;
-(void)initGR;

@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Title;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Outline;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PubDate;

@end
