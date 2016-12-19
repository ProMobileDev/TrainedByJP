//
//  TopicDetailController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 31/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "TopicDetailController.h"

#define TOTAL_PAGE_SIZE 20

@interface TopicDetailController ()

@end

@implementation TopicDetailController
{
    UITextField *mCommentBox;
    float mScrollHeight;
}

-(IBAction)subscribeBtnPressed:(id)sender
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    NSString *subscribed = nil;
    NSDictionary *params = nil;
    if (![[self.mainDict objectForKey:@"subscribed"] boolValue])
    {
        subscribed = @"1";
        params =  [UrlManager getSubscribeTopicDetailParameters:self.mainDict subscribe:@"1"];
    }
    else
    {
        subscribed = @"0";
        params =  [UrlManager getUnSubscribeTopicDetailParameters:self.mainDict];
    }
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [indicator hideAnimated:YES];
         
         NSError *error = nil;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
         
         if (error)
         {
             [Utilities errorDisplay:@"Unable to parse response from server" controller:self];
             return ;
         }
         
         if (![[dict objectForKey:RESPONSE_KEY_SUCCESS] boolValue])
         {
             [Utilities errorDisplay:[dict objectForKey:RESPONSE_KEY_MESSAGE] controller:self];
         }
         else
         {
             [self.mainDict setObject:subscribed forKey:@"subscribed"];
         }
         
         if (![[self.mainDict objectForKey:@"subscribed"] boolValue])
             [self.mSubscribeBtn setTitle:@"+ Subscribe to this topic for updates" forState:UIControlStateNormal];
         else
             [self.mSubscribeBtn setTitle:@"- Unsubscribe from this topic" forState:UIControlStateNormal];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [indicator hideAnimated:YES];
         
         if (error)
         {
             [Utilities errorDisplay:error.localizedDescription controller:self];
         }
         
     }];
}

-(IBAction)createBtnPressed:(id)sender
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    NSDictionary *params = [UrlManager getCreateTopicReplyParameters:self.mainDict content:self.topicContent.text tags:self.topicTags.text subscription:self.mNotifOption ? @"1" : @"0"];
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [indicator hideAnimated:YES];
         
         NSError *error = nil;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
         
         if (error)
         {
             [Utilities errorDisplay:@"Unable to parse response from server" controller:self];
             return ;
         }
         
         if (![[dict objectForKey:RESPONSE_KEY_SUCCESS] boolValue])
         {
             [Utilities errorDisplay:[dict objectForKey:RESPONSE_KEY_MESSAGE] controller:self];
         }
         
         [self.mTable reloadData];
         [self.createView setHidden:YES];         
         [self callApi];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [indicator hideAnimated:YES];
         
         if (error)
         {
             [Utilities errorDisplay:error.localizedDescription controller:self];
         }         
     }];
}

-(IBAction)pageBtnPressed:(id)sender
{
    if (self.selectedBtn != nil)
    {
        [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.selectedBtn setBackgroundColor:[UIColor clearColor]];
    }
    
    self.selectedBtn = (UIButton *)sender;
    [self.selectedBtn setBackgroundColor:[UIColor colorWithRed:56/255.0 green:81/255.0 blue:121.0/255.0 alpha:1]];
    [self.selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
    self.commentsArray = [[NSMutableArray alloc] init];
    
    long tag = ((UIButton *)sender).tag;
    long startValue = tag * TOTAL_PAGE_SIZE;
    
    for (long i = startValue; i < startValue + TOTAL_PAGE_SIZE; i++)
    {
        if (self.mainCommentsArray.count > i)
            [self.commentsArray addObject:[self.mainCommentsArray objectAtIndex:i]];
    }
    
    [self.mTable reloadData];
}

-(IBAction)cancelBtnPressed:(id)sender
{
    [self.createView setHidden:YES];
}

-(IBAction)replyBtnPressed:(id)sender
{
    [self.createView setHidden:NO];
}

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainDict = [[NSMutableDictionary alloc] initWithDictionary:[ApiManager sharedInstance].selectedDict];
    self.commentsArray = [[NSMutableArray alloc] init];
    
    mScrollHeight = 1.0f;
     self.commentsArray = [[NSMutableArray alloc] init];
    [self.titleText setText:[self.mainDict objectForKey:@"topic_title"]];
    
    [self callApi];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) callApi
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:[UrlManager getTopicDetailParameters:self.mainDict] progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [indicator hideAnimated:YES];
         
         NSError *error = nil;
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
         
         if (error)
         {
             [Utilities errorDisplay:@"Unable to parse response from server" controller:self];
             return ;
         }
         
         if (![[dict objectForKey:RESPONSE_KEY_SUCCESS] boolValue])
         {
             [Utilities errorDisplay:[dict objectForKey:RESPONSE_KEY_MESSAGE] controller:self];
         }
         else
         {
             self.htmlString = [Utilities getFontAppliedHTMLString:[[dict objectForKey:@"topic"] objectForKey:@"topic_content"]];

             if (![[[dict objectForKey:@"topic"] objectForKey:@"replies"] isKindOfClass:[NSNull class]])
                 self.mainCommentsArray = [[dict objectForKey:@"topic"] objectForKey:@"replies"];
             
             self.mainDict = [dict objectForKey:@"topic"];
             
             [self.titleText setText:[self.mainDict objectForKey:@"topic_title"]];
             
             if (![[self.mainDict objectForKey:@"subscribed"] boolValue])
                 [self.mSubscribeBtn setTitle:@"+ Subscribe to this topic for updates" forState:UIControlStateNormal];
             else
                 [self.mSubscribeBtn setTitle:@"- Unsubscribe from this topic" forState:UIControlStateNormal];
             
             long x = 0;
             long totalPages = self.mainCommentsArray.count / TOTAL_PAGE_SIZE  + 1;
             for (int i = 0; i < totalPages; i++)
             {
                 x = i * 35;
                 UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 30, 30)];
                 [btn setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
                  btn.tag = i;
                 [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 [btn addTarget:self action:@selector(pageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                 [self.mScrollView addSubview:btn];

                 if (i == 0)
                     [self pageBtnPressed:btn];
             }
             
             [self.mScrollView setContentSize:CGSizeMake(totalPages * 35 + 40, 30)];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [indicator hideAnimated:YES];
         
         if (error)
         {
             [Utilities errorDisplay:error.localizedDescription controller:self];
         }
     }];
}

#pragma mark - TableView Api
/*********************************************************************************************
 *
 *                          TABLE VIEW DELEGATE FUNCTIONS
 *
 *********************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    else
        return 30.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return mScrollHeight;
    }
    else
    {
        NSDictionary *dict = [self.commentsArray objectAtIndex:indexPath.row];
        long height = 0;
        if ([dict objectForKey:@"height"] != nil)
        {
            height = [[dict objectForKey:@"height"] integerValue];
        }
        
        if (height > 30)
        {
            CGFloat mSize = 65 + height;
            if (mSize < 80)
            {
                mSize = 80;
            }
            return mSize;
        }
        return 80;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        [cell setPreservesSuperviewLayoutMargins:NO];
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    else
        return [self.commentsArray count];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *mView;
        UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(12 , 0, self.view.frame.size.width, 30)];
        [mLabel setTextColor:[UIColor blackColor]];
        mView  = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
        
        if (self.commentsArray.count != 0)
            [mLabel setText:@"REPLIES"];
        
        [mLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [mView setBackgroundColor:[UIColor clearColor]];
        [mView addSubview:mLabel];
        
        return mView;
    }
    else
    {
        UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.1)];
        return mView;    
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"CommentCell";
    if (indexPath.section == 1)
    {
        ForumCellModel *cell = [self.mTable dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
        NSDictionary *dict = [self.commentsArray objectAtIndex:indexPath.row];
        cell.content.tag = indexPath.row;

        cell.titleText.text = [dict objectForKey:@"reply_author"];
        cell.timeText.text  = [dict objectForKey:@"create_date"];
        
        [cell.content loadHTMLString:[Utilities getFontAppliedHTMLString:[dict objectForKey:@"reply_content"]] baseURL:[NSURL URLWithString:BASE_URL]];

        if ([dict objectForKey:@"height"] != nil)
        {
            long height = [[dict objectForKey:@"height"] integerValue];
            [cell.content setFrame:CGRectMake(cell.content.frame.origin.x, cell.content.frame.origin.y, cell.contentView.frame.size.width - 10 - cell.forumImg.frame.size.width, height + 10)];
            [cell.content setDelegate:nil];
        }
        else
            [cell.content setDelegate:self];
        
        if (![[dict objectForKey:@"author_avatar"] isKindOfClass:[NSNull class]])
            [cell.forumImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"author_avatar"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
        
        [cell.content setBackgroundColor:[UIColor clearColor]];
         cell.content.opaque = NO;
        
        for (id subview in cell.content.subviews) {
            if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
                [subview setBounces:NO];
            }
        }
        [cell.content setUserInteractionEnabled:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        self.mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width - 5, mScrollHeight)];
        [cell.contentView addSubview:self.mWebView];
        [self.mWebView loadHTMLString:self.htmlString baseURL:[NSURL URLWithString:BASE_URL]];
        
        if (mScrollHeight < 9.0f )
        {
            [self.mWebView setDelegate:self];
        }
        
        //Disable bouncing in webview
        for (id subview in self.mWebView.subviews) {
            if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
                [subview setBounces:NO];
            }
        }
        [self.mWebView setUserInteractionEnabled:NO];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    frame.size.height = 5.0f;
    webView.frame = frame;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)]; // Pass about any size
    CGRect mWebViewFrame = webView.frame;
    mWebViewFrame.size.height = mWebViewTextSize.height;
    webView.frame = mWebViewFrame;
    
    if (self.mWebView != webView)
    {
        long tag = webView.tag;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self.commentsArray objectAtIndex:tag]];
        [dict setObject:[NSString stringWithFormat:@"%f", mWebViewFrame.size.height] forKey:@"height"];
        [self.commentsArray replaceObjectAtIndex:tag withObject:dict];
    }
    else
        mScrollHeight = mWebViewFrame.size.height;
    
    //Disable bouncing in webview
    for (id subview in webView.subviews) {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            [subview setBounces:NO];
        }
    }
    [webView setUserInteractionEnabled:NO];
    [webView setDelegate:nil];
    [self.mTable reloadData];
}


@end
