//
//  CommentCell.h
//  NextApp
//
//  Created by wangjun on 12-1-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell


@property (strong,nonatomic) IBOutlet UILabel *lbl_Author;
@property (strong,nonatomic) IBOutlet UILabel *lbl_PubDate;
@property (strong,nonatomic) IBOutlet UILabel *lbl_Body;
//长按删除元素用
@property (nonatomic,assign) id delegate;
-(void)initGR;

@end
