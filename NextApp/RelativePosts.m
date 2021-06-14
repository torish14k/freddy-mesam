//
//  RelativePosts.m
//  NextApp
//
//  Created by wangjun on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RelativePosts.h"

@implementation RelativePosts
@synthesize tableRelativePosts;
@synthesize singlePost;
@synthesize comments;
@synthesize parent;
#pragma mark - View lifecycle

-(void)viewDidAppear:(BOOL)animated
{
    self.title = @"相关文章";
}
-(void)reload
{
    [self.tableRelativePosts reloadData];
}

- (void)viewDidUnload
{
    [self setTableRelativePosts:nil];
    [self setTableRelativePosts:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma TableView 的相关处理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (DataSingleton.Instance.postToShare != nil&&
        DataSingleton.Instance.postToShare.relativePosts != nil) {
        int count = [DataSingleton.Instance.postToShare.relativePosts count];
        return count > 0 ? count : 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (DataSingleton.Instance.postToShare.relativePosts != nil) {
        
        if ([DataSingleton.Instance.postToShare.relativePosts count] > 0) {

            RelativePostCell *cell = (RelativePostCell *)[tableView dequeueReusableCellWithIdentifier:RelativePostCellIdentifier];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RelativePostCell" owner:self options:nil];
                for (NSObject *object in objects) {
                    if ([object isKindOfClass:[RelativePostCell class]]) {
                        cell = (RelativePostCell *)object;
                    }
                }
            }
            [cell initGR];
            [cell setDelegate:self];
            //配置cell的属性
            RelativePost *rp = [DataSingleton.Instance.postToShare.relativePosts objectAtIndex:[indexPath row]];
            if (rp) {
                cell.lbl_Title.text = rp.title;
                cell.lbl_Author.text = rp.author;
                cell.lbl_PubDate.text = [Tool toDate:rp.pubDate];
            }
            return cell;
        }
        else
        {
            static NSString *nextIdentifier = @"loadMore";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nextIdentifier];
            if (cell == nil) 
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nextIdentifier];
            }
            cell.textLabel.text = @"没有相关文章";
            return  cell;
        }
    }
    else
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RelativePost *rPost = [DataSingleton.Instance.postToShare.relativePosts objectAtIndex:[indexPath row]];
    DataSingleton.Instance.postToShare._id = rPost._id;
    //通知作出响应
    if (singlePost != nil) {
        //文章详情去自我加载
        [singlePost initPostDetail];
    }
    if (comments != nil) {
        //评论列表自我加载
        [comments reloadComments4ChangePost];
    }
    if (parent != nil) {
        //立即切换到 文章详情页
        parent.segments.selectedSegmentIndex = 0;
        //还要切换 view
        [parent segementSelectedIndexChanged:parent.segments];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

//显示菜单  
- (void)showMenu:(id)cell
{  
    //如果没有登录
    if ([Config.Instance isLogin] == NO) {
        return;
    }
    [cell becomeFirstResponder];  
    UIMenuController * menu = [UIMenuController sharedMenuController];  
    CGRect rect = [cell frame];
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y - tableRelativePosts.contentOffset.y, rect.size.width, rect.size.height);
    [menu setTargetRect:newRect inView:[self view]];
    [menu setMenuVisible: YES animated: YES];    
}  
- (void)deleteRow:(UITableViewCell *)cell
{
    /*
     检测是否已经登录  如果没有登录 则直接弹出登录提示页
     */
    if ([Config.Instance isLogin]) {
        
        NSIndexPath *path = [tableRelativePosts indexPathForCell:cell];
        Post *p = [DataSingleton.Instance.postToShare.relativePosts objectAtIndex:path.row];
        if (p != nil) {
            [self delPost:p._id];
        }
    }
    else    
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法删除" message:@"您还没有登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"登录", nil];
        [alert show];
    }
} 
-(void)delPost:(int)_id
{
    alertDelPost = [Tool getLoadingView:@"载入中" andMessage:@"正在提交删除文章"];
    [alertDelPost show];
    
    NSMutableURLRequest *request = [Tool getHttpRequest:@"GET" andUrl:Config.Instance.api_PostDel andBody:[NSString stringWithFormat:@"post=%d", _id] andCookie:[Config.Instance getCookieEntity]];
    
    receivedDelPost = [[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedDelPost appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (alertDelPost) {
        [alertDelPost dismissWithClickedButtonIndex:0 animated:YES];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (receivedDelPost) {
        Xml_ApiError *x = [[Xml_ApiError alloc] initWithData:receivedDelPost];
        [x setDelegate:x];
        [x parse];
        switch (x.error.errorCode) {
            case 1:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除成功" message:@"文章删除成功" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case 0:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"用户未登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case -2:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"没有删除权限" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case -1:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"其他错误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
        }
    }
}

@end
