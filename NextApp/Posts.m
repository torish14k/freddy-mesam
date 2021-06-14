//
//  Posts.m
//  NextApp
//
//  Created by wangjun on 11-12-31.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Posts.h"

@implementation Posts
@synthesize tablePosts;

@synthesize posts;



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initControls];
    [self reloadPosts];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self initPostlistLayout]; 
    
    isInitialize = YES;
}

-(void)initPostlistLayout{
    
    int layout = Config.Instance.getPostListLayout;
    BOOL isNeedReload = NO;
    //如果已经初始化过 则判断是否更改了显示模式
    if (isInitialize == YES && currentLayout != 0) {
        if (currentLayout != layout) {
            isNeedReload = YES;
        }
    }
    currentLayout = layout;
    if (isNeedReload == YES) {
        [self btn_ReloadPosts_Click:nil];
    }
}
-(void)initControls
{
    self.posts = [[NSMutableArray alloc] initWithCapacity:20];
    
    self.title = @"最新文章";
    //设置文章分类的按钮事件
    UIBarButtonItem *btn_Catalogs = [[UIBarButtonItem alloc] initWithTitle:@"文章分类" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.leftBarButtonItem = btn_Catalogs;
    [btn_Catalogs setAction:@selector(btn_Catalogs_Click:)];
    
    UIBarButtonItem *btn_ReloadPosts = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.rightBarButtonItem = btn_ReloadPosts;
    [btn_ReloadPosts setAction:@selector(btn_ReloadPosts_Click:)];
}
-(int)getLastPostID
{
    if ([self.posts count] > 0) {
        Post *p = [self.posts objectAtIndex:([self.posts count]-1)];
        return p._id;
    }
    else{
        return 0;
    }
}
-(int)getCatalogID
{
    return DataSingleton.Instance.currentCatalog == nil ? 0 : DataSingleton.Instance.currentCatalog._id;
}
//整体重新加载
-(void)reloadPosts
{
    if ([self.posts count] == 0) {
        if (!alertPosts) {
            alertPosts = [Tool getLoadingView:@"载入中" andMessage:@"正在加载文章列表"];
        }
        [alertPosts show];
    }
    int cID = [self getCatalogID];
    NSMutableURLRequest *request = [Tool 
                                    getHttpRequest:@"GET" 
                                    andUrl:Config.Instance.api_Posts 
                                    andBody:[NSString stringWithFormat:@"catalog=%d&fromPost=%d&fectchCount=%d",[self getCatalogID],[self getLastPostID],MaxCount_ReloadPosts]
                                    andCookie:nil];
    receivedPosts = [[NSMutableData alloc] initWithData:nil];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedPosts appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (alertPosts) {
        [alertPosts dismissWithClickedButtonIndex:0 animated:YES];
    }
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (receivedPosts != nil) {
        Xml_Posts *x = [[Xml_Posts alloc] initWithData:receivedPosts];
        [x setDelegate:x];
        [x parse];
        if (x.postList != nil) {
            for (int i=0; i<[x.postList.posts count]; i++) {
                Post *p = [x.postList.posts objectAtIndex:i];
                if ([DataProvider isRepeatPost:self.posts byID:p._id] == NO) {
                    [self.posts addObject:p];
                }
            }
            isLoadOver = [x.postList.posts count]>0 ? NO:YES;
            //显示出来
            [self.tablePosts reloadData];
        }
        else
        {
            isLoadOver = YES;
        }
    }
}

-(IBAction)btn_Catalogs_Click:(id)sender
{
    NSString *test_str = NSLocalizedString(@"HELLO", nil);
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择文章分类" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"返回"
//        otherButtonTitles:@"最新文章", 
//        nil];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择文章分类" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"返回" otherButtonTitles:@"最新文章", nil];
    
    for (int i=0; i<[DataSingleton.Instance.catalogs count]; i++) 
    {
        Catalog *c = (Catalog *)[DataSingleton.Instance.catalogs objectAtIndex:i];
        [sheet addButtonWithTitle:c.name];
    }	
    //显示
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //获取点击按钮的标题
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"返回"]) {
        return;
    }
    Catalog *newCatalog = [DataProvider getCatalog:DataSingleton.Instance.catalogs byName:buttonTitle];
    if (newCatalog != nil) 
    {
        DataSingleton.Instance.currentCatalog = newCatalog;
        //修改标题
//        self.title = DataSingleton.Instance.currentCatalog.name;
        if (DataSingleton.Instance.currentCatalog.name.length > 7) {
            self.title = [NSString stringWithFormat:@"%@..",[DataSingleton.Instance.currentCatalog.name substringToIndex:6]];
        }
        else{
            self.title = DataSingleton.Instance.currentCatalog.name;
        }
    }
    else
    {
        DataSingleton.Instance.currentCatalog = nil;
        //修改标题
        self.title = @"最新文章";
    }
    //这里要进行不是页面跳转 而是重新加载本Posts页面
    [self.posts removeAllObjects];
    [self reloadPosts]; 
}
-(IBAction)btn_ReloadPosts_Click:(id)sender
{
    [self.posts removeAllObjects];
    [self reloadPosts];
}

- (void)viewDidUnload
{
    [self setTablePosts:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.posts = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma TableView相关处理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     注意 如果返回的是 [self.comments count] + 1
     则长按删除的功能将消失
     
     最终我们检测出问题是在 可以让前5篇文章具备 长按删除的功能 但后面的文章将不具备这个功能
     */
    return [self.posts count] + 1;
    
//    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.posts count]) 
    {
        int layout = Config.Instance.getPostListLayout;
        switch (layout) {
            case 1:
            {
                //纯粹文字
                PostCell *cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:PostCellIdentifier];
                if (!cell) {
                    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
                    for (NSObject *object in objects) {
                        if ([object isKindOfClass:[PostCell class]]) {
                            cell = (PostCell *)object;
                            break;
                        }
                    }
                }
                [cell initGR];
                [cell setDelegate:self];
                //配置cell属性
                Post *p = [self.posts objectAtIndex:[indexPath row]];
                if (p) {
                    cell.lbl_Title.text = p.title;
                    cell.lbl_Outline.text = p.outline;
                    cell.lbl_Author.text = p.author;
                    cell.lbl_PubDate.text = [Tool toDate:p.pubDate];
                    cell.lbl_CommentsCount.text = [NSString stringWithFormat:@"%d", p.commentCount];
                }
                return cell;
            }
                break;
            case 2:
            {
                //小型边框
                PostCellBig *cell = (PostCellBig *)[tableView dequeueReusableCellWithIdentifier:@"PostCellIdentifier2"];
                if (!cell) {
                    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"PostCellBig" owner:self options:nil];
                    for (NSObject *object in objects) {
                        if ([object isKindOfClass:[PostCellBig class]]) {
                            cell = (PostCellBig *)object;
                            break;
                        }
                    }
                }
                [cell initGR];
                [cell setDelegate:self];
                //配置cell属性 
                Post *p = [self.posts objectAtIndex:[indexPath row]];
                if (p) {
                    cell.lbl_Title.text = p.title;
                    cell.lbl_Outline.text = p.outline;
                    cell.lbl_PubDate.text = p.pubDate;
                        if (p.img != nil) {
                            if (p.imgData == nil) {
                                p.imgData = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:p.img]]];
                            }
                            cell.img.image = p.imgData;
                        }
                        else{
                            cell.img.image = [UIImage imageNamed:@"image_loading.png"];
                        }
                }
                return cell;
            }
                break;
            case 3:
            {
                //大型边框
                PostCellTitle *cell = (PostCellTitle *)[tableView dequeueReusableCellWithIdentifier:@"PostCellIdentifier3"];
                if (!cell) {
                    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"PostCellTitle" owner:self options:nil];
                    for (NSObject *object in objects) {
                        if ([object isKindOfClass:[PostCellTitle class]]) {
                            cell = (PostCellTitle *)object;
                            break;
                        }
                    }
                }
                [cell initGR];
                [cell setDelegate:self];
                //配置cell属性
                Post *p = [self.posts objectAtIndex:[indexPath row]];
                if (p) {
                    cell.lbl_Title2.text = p.title;
                    if (p.img != nil) {
                        if (p.imgData == nil) {
                            p.imgData = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:p.img]]];
                        }
                        cell.img.image = p.imgData;
                    }
                    else{
                        cell.img.image = [UIImage imageNamed:@"image_loading.png"];
                    }
//                    if (p.img != nil && [p.img length] > 8) {
//                        cell.img.image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:p.img]]];
//                    }
//                    else{
//                        cell.img.image = [UIImage imageNamed:@"image_loading.png"];
//                    }
                }
                return cell;
            }
            break;
        }
    }
    else
    {
        static NSString *nextIdentifier = @"loadMore";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nextIdentifier];
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nextIdentifier];
        }
        cell.textLabel.text = isLoadOver ? @"已经加载全部文章" : @"正在加载...";
        if (isLoadOver == NO) {
            [self performSelector:@selector(reloadPosts)];
        }
        return  cell;
    }
}
//注意返回的高度设置还是必须要到此方法中来设置
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //纯粹文字适合的高度
//    return 86;
    //小边框适合的高度
//    return 94;
    //大边框适合的高度
//    return 120;

//    if ([currentLayout isEqualToString:@"border1"]) {
//        return 140;
//    }
//    else if([currentLayout isEqualToString:@"border2"]){
//        return 94;
//    }
//    else {
//        return 86;
//    }
    
    int layout = Config.Instance.getPostListLayout;
    switch (layout) {
        case 1:
            return 86;
        case 2:
            return 94;
        case 3:
            return 140;
    }
}
//点击某个文章的事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < [self.posts count]) 
    {
        //进入
        Post *p = [self.posts objectAtIndex:[indexPath row]];
        //然后指定 postToShare 的 id
        DataSingleton.Instance.postToShare._id = p._id;
        //添加指定的view
        Single *singlePost = [Single new];
        singlePost.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:singlePost animated:YES];
    }
}

//显示菜单  
- (void)showMenu:(id)cell
{  
    //如果没有登录 则没有反映
    if ([Config.Instance isLogin] == NO) {
        return;
    }
    [cell becomeFirstResponder];  
    UIMenuController * menu = [UIMenuController sharedMenuController];  
    CGRect rect = [cell frame];
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y - tablePosts.contentOffset.y, rect.size.width, rect.size.height);
    [menu setTargetRect:newRect inView:[self view]];
    [menu setMenuVisible: YES animated: YES];  
}  
- (void)deleteRow:(UITableViewCell *)cell
{
    /*
     检测是否已经登录  如果没有登录 则直接弹出登录提示页
     */
    if ([Config.Instance isLogin]) {

        NSIndexPath *path = [tablePosts indexPathForCell:cell];
        Post *p = [self.posts objectAtIndex:path.row];
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
    [PostDelete.Instance deletePost:_id];
    PostDelete.Instance.parent = self;
}

@end
