//
//  Comments.m
//  NextApp
//
//  Created by wangjun on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Comments.h"

@implementation Comments
@synthesize tableComments;
@synthesize comments;
@synthesize isBelongToOnePost;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControls];
    [self reloadComments];
}
-(void)initControls
{
    self.comments = [[NSMutableArray alloc] initWithCapacity:100];
    self.title = @"最新评论";
    UIBarButtonItem *btn_ReloadComments = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.rightBarButtonItem = btn_ReloadComments;
    [btn_ReloadComments setAction:@selector(btn_ReloadComments_Click:)];
}
-(int)getPostID
{
    //获取 post ID
    int postID = 0;
    if(isBelongToOnePost && DataSingleton.Instance.postToShare != nil)
    {
        postID = DataSingleton.Instance.postToShare._id;
    }
    return postID;
}
-(int)getLastCommentID
{
    if ([self.comments count] > 0) {
        Comment *c = [self.comments objectAtIndex:([self.comments count]-1)];
        return c._id;
    }
    else
    {
        return 0;
    }
}
-(void)reloadComments4ChangePost
{
    [self.comments removeAllObjects];
    [self reloadComments];
}
-(void)reloadComments
{
    if ([self.comments count] == 0 && isBelongToOnePost == NO) {
        if (!alertComments) {
            alertComments = [Tool getLoadingView:@"载入中" andMessage:@"正在加载评论列表"];
        }
        [alertComments show];
    }
    NSMutableURLRequest *request = [Tool getHttpRequest:@"GET" 
                                                 andUrl:Config.Instance.api_Comments andBody:[NSString stringWithFormat:@"post=%d&fromComment=%d&fetchCount=%d",[self getPostID],[self getLastCommentID], MaxCount_ReloadComments]
                                              andCookie:nil];
    receivedComments = [[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedComments appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (alertComments) {
        [alertComments dismissWithClickedButtonIndex:0 animated:YES];
    } 
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (receivedComments != nil) {
        isLoadOnce = YES;
        Xml_Comments *x = [[Xml_Comments alloc] initWithData:receivedComments];
        [x setDelegate:x];
        [x parse];
        if (x.commentsList != nil) {
            if (x.commentsList.comments != nil) {
                //赋值
                for (int i=0; i<[x.commentsList.comments count]; i++) {
                    
                    Comment *c = [x.commentsList.comments objectAtIndex:i];
                    if ([DataProvider isRepeatComment:self.comments byID:c._id] == NO) {
                        [self.comments addObject:c];
                    }
                }
                isLoadOver = [x.commentsList.comments count] > 0 ? NO : YES;
                //显示
                [self.tableComments reloadData];
            }
            else
            {
                isLoadOver = YES;
            }
        }
        else
        {
            isLoadOver = YES;
        }

    }
}

-(IBAction)btn_ReloadComments_Click:(id)sender
{
    [self.comments removeAllObjects];
    [self reloadComments];
}

- (void)viewDidUnload
{
    [self setTableComments:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.comments = nil;
}

#pragma TabelView处理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     注意 如果返回的是 [self.comments count] + 1
     则长按删除的功能将消失
     */
    if (self.comments != nil) {
        int count = [self.comments count];
        return count > 0 ? count + 1 : 1;
    }
    else
        return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.comments == nil) {
        return nil;
    }
    if ([self.comments count] > 0) {
        if (indexPath.row < [self.comments count]) {

            CommentCell *cell = nil;
            cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
            if (!cell) {
                NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
                for (NSObject *object in objects) {
                    if ([object isKindOfClass:[CommentCell class]]) {
                        cell = (CommentCell *)object;
                        break;
                    }
                }
            }
            [cell initGR];
            [cell setDelegate:self];
            Comment *c = [self.comments objectAtIndex:[indexPath row]];
            if (c) {
                cell.lbl_Author.text = c.name;
                cell.lbl_PubDate.text = [Tool toTimeNoSeconds:c.pubDate];
                cell.lbl_Body.text = c.body;
            }
            
            return  cell;
        }
        //显示等待加载
        else
        {
            static NSString *nextIdentifier = @"loadMore";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nextIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nextIdentifier];
            }
            cell.textLabel.text = isLoadOver ? @"已经加载全部评论": @"正在加载...";
            if (isLoadOver == NO) {
                [self performSelector:@selector(reloadComments)];
            }
            return  cell;
        }
    }
    else
    {
        static NSString *nextIdentifier = @"loadMore";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nextIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nextIdentifier];
        }
        cell.textLabel.text = isLoadOnce ? @"没有相关评论" : @"正在加载...";
        if (isLoadOver == NO) {
            [self performSelector:@selector(reloadComments)];
        }
        return  cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.comments count]) {
        //进入这篇文章的详情页面
        Comment *c = [self.comments objectAtIndex:[indexPath row]];
        if (c != nil) {
            DataSingleton.Instance.postToShare._id = c.post;
            //添加指定的view
            Single *singlePost = [Single new];
            singlePost.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:singlePost animated:YES];
        }
    }
}
//显示菜单  
- (void)showMenu:(id)cell
{  
    //如果没有登录
    if ([Config.Instance isLogin] == NO) {
        return;
    }
    [cell becomeFirstResponder];  
    UIMenuController *menu = [UIMenuController sharedMenuController];  
    CGRect rect = [cell frame];
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y - tableComments.contentOffset.y, rect.size.width, rect.size.height);
    [menu setTargetRect:newRect inView:[self view]];
    [menu setMenuVisible: YES animated: YES];  
}  

- (void)deleteRow:(UITableViewCell *)cell
{
    /*
     检测是否已经登录  如果没有登录 则直接弹出登录提示页
     */
    if ([Config.Instance isLogin]) {
        NSIndexPath *path = [tableComments indexPathForCell:cell];
        Comment *c = [self.comments objectAtIndex:path.row];
        if (c != nil) {
            [self delComment:c._id];
        }
    }
    else    
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法删除" message:@"您还没有登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"登录", nil];
        [alert show];
    }
} 
-(void)delComment:(int)_id
{
    [CommentDelete.Instance deleteComment:_id];
    CommentDelete.Instance.parent = self;
}

@end



















