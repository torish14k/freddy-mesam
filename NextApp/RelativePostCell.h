//
//  RelativePostCell.h
//  NextApp
//
//  Created by wangjun on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelativePostCell : UITableViewCell

@property (strong,nonatomic) IBOutlet UILabel *lbl_Title;
@property (strong,nonatomic) IBOutlet UILabel *lbl_Author;
@property (strong,nonatomic) IBOutlet UILabel *lbl_PubDate;
//长按删除元素用
@property (nonatomic,assign) id delegate;
-(void)initGR;

@end
