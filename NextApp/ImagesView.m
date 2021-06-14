//
//  ImagesView.m
//  NextApp
//
//  Created by wangjun on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImagesView.h"

#import <QuartzCore/QuartzCore.h>
#import "GMGridView.h"

@interface ImagesView() <GMGridViewDataSource,GMGridViewSortingDelegate,GMGridViewTransformationDelegate,GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
}
@end

@implementation ImagesView
#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSInteger spacing = 10;

    CGRect rect = self.view.bounds;
    rect = CGRectMake(0,43,rect.size.width, rect.size.height-43);
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:rect];
    
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    //    [self.navigationController.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = NO;
    _gmGridView.actionDelegate = self;
    _gmGridView.sortingDelegate = self;
    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.editing = YES;
    _gmGridView.mainSuperView = self.navigationController.view;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [DataSingleton.Instance.imgs count];
}

- (CGSize)sizeForItemsInGMGridView:(GMGridView *)gridView
{
    return CGSizeMake(140, 110);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    CGSize size = [self sizeForItemsInGMGridView:gridView];
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor blueColor];
        view.layer.masksToBounds = NO;
        view.layer.cornerRadius = 8;
        view.layer.shadowColor = [UIColor grayColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(5, 5);
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        view.layer.shadowRadius = 8;
        
        cell.contentView = view;
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImage *_img = [DataSingleton.Instance.imgs objectAtIndex:index];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (_img) {
        imgView.image = _img;
        [cell.contentView addSubview:imgView];
    }
    return cell;
}

- (void)GMGridView:(GMGridView *)gridView deleteItemAtIndex:(NSInteger)index
{
    //作为处理
    [DataSingleton.Instance.imgs removeObjectAtIndex:index];
    //然后进行刷新
    [_gmGridView reloadData];
}

- (void)addMoreItem
{
    [_gmGridView insertObjectAtIndex:[DataSingleton.Instance.imgs count] - 1];
}



#pragma 选择图片
- (IBAction)click_ChoseImgs:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"返回" otherButtonTitles:@"图库",@"拍照", nil];
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取点击按钮的标题
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"拍照"])
    {
        
        UIImagePickerController *imgPicker = [UIImagePickerController new];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imgPicker animated:YES];
    }
    else if([buttonTitle isEqualToString:@"图库"])
    {

        UIImagePickerController *imgPicker = [UIImagePickerController new];
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:imgPicker animated:YES];
    }
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    //添加到集合中
    [DataSingleton.Instance.imgs addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    //刷新
    [_gmGridView reloadData];
}
//用户取消选择某张图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}
//点击顶部的完成按钮
- (IBAction)click_Close:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}


#pragma 表格处理
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIImage *_img = [DataSingleton.Instance.imgs objectAtIndex:[indexPath row]];
//    if (_img != nil) {
//        cell.imageView.image = _img;
//        cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x + 200, cell.imageView.frame.origin.y, cell.imageView.frame.size.width, cell.imageView.frame.size.height);
//    }
//}
//- (void)deleteRow:(UITableViewCell *)cell
//{
//    NSIndexPath *path = [tableImgs indexPathForCell:cell];
//    [DataSingleton.Instance.imgs removeObjectAtIndex:[path row]];
//    //刷新
//    [self.tableImgs reloadData];
//} 

@end
