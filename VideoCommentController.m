//
//  VideoCommentController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 03/09/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "VideoCommentController.h"
#import <QuartzCore/QuartzCore.h>


#define TOTAL_PAGE_SIZE 20

@interface VideoCommentController ()

@end

@implementation VideoCommentController

-(IBAction)replyBtnPressed:(id)sender
{
    if ([_commentBox.text isEqualToString:@""] ||[_commentBox.text isEqualToString:@"Write a comment"] )
    {
        [Utilities errorDisplay:@"Please add your comment" controller:self];
    }
    currentPageIndex = 1;
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:[UrlManager getVideoAddCommentsParameters:currentPageIndex videoId:[self.mainDict objectForKey:@"id"] text:_commentBox.text] progress:^(NSProgress * _Nonnull uploadProgress)
     {
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
             _commentBox.text = @"";
             
             dict = [dict objectForKey:@"comments"];
             NSDictionary *pagesDict = [dict objectForKey:@"pages"];
             
             for (int i = 0; i < self.mScrollView.subviews.count; i++)
                 [[self.mScrollView.subviews objectAtIndex:i] removeFromSuperview];
             
             long x = 0;
             for (int i = 0; i < [[pagesDict objectForKey:@"total_pages"] integerValue]; i++)
             {
                 x = i * 35;
                 UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 30, 30)];
                 [btn setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
                 btn.tag = i + 1;
                 [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 [self.mScrollView addSubview:btn];
                 
                 if ([[pagesDict objectForKey:@"current_page"] integerValue] == (i + 1))
                 {
                     [btn setBackgroundColor:[UIColor colorWithRed:56/255.0 green:81/255.0 blue:121.0/255.0 alpha:1]];
                     [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 }
                 else
                     [btn addTarget:self action:@selector(pageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
             }
             
             self.commentsArray = [dict objectForKey:@"comments"];
             
             [self.mScrollView setContentSize:CGSizeMake([[pagesDict objectForKey:@"total_pages"] integerValue] * 35 + 40, 30)];
             [self.mTable reloadData];
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

-(IBAction)backBtnPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentPageIndex = 1;
     self.commentsArray = [[NSMutableArray alloc] init];
    [self callApi];
    
    [self.commentBox setDelegate:self];
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
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:[UrlManager getVideoCommentsParameters:currentPageIndex videoId:[self.mainDict objectForKey:@"id"]] progress:^(NSProgress * _Nonnull uploadProgress)
     {
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
             dict = [dict objectForKey:@"comments"];
             NSDictionary *pagesDict = [dict objectForKey:@"pages"];
             
             for (int i = 0; i < self.mScrollView.subviews.count; i++)
                 [[self.mScrollView.subviews objectAtIndex:i] removeFromSuperview];
             
             long x = 0;
             for (int i = 0; i < [[pagesDict objectForKey:@"total_pages"] integerValue]; i++)
             {
                 x = i * 35;
                 UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 30, 30)];
                 [btn setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
                 btn.tag = i + 1;
                 [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 [self.mScrollView addSubview:btn];
                 
                 if ([[pagesDict objectForKey:@"current_page"] integerValue] == (i + 1))
                 {
                     [btn setBackgroundColor:[UIColor colorWithRed:56/255.0 green:81/255.0 blue:121.0/255.0 alpha:1]];
                     [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 }
                 else
                     [btn addTarget:self action:@selector(pageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
             }
             
             self.commentsArray = [dict objectForKey:@"comments"];
             
             [self.mScrollView setContentSize:CGSizeMake([[pagesDict objectForKey:@"total_pages"] integerValue] * 35 + 40, 30)];
             [self.mTable reloadData];
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

-(void)pageBtnPressed:(id)sender
{
    currentPageIndex = ((UIButton *)sender).tag;
    [self callApi];
}


#pragma mark - TableView Api
/*********************************************************************************************
 *
 *                          TABLE VIEW DELEGATE FUNCTIONS
 *
 *********************************************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
    return [self.commentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"CommentCell";
    ForumCellModel *cell = [self.mTable dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
    NSDictionary *dict = [self.commentsArray objectAtIndex:indexPath.row];
    cell.content.tag = indexPath.row;
    
    cell.titleText.text = [dict objectForKey:@"display_name"];
    cell.timeText.text  = [dict objectForKey:@"date"];
    
    [cell.content loadHTMLString:[Utilities getFontAppliedHTMLString:[dict objectForKey:@"comment"]] baseURL:[NSURL URLWithString:BASE_URL]];
    
    if ([dict objectForKey:@"height"] != nil)
    {
        long height = [[dict objectForKey:@"height"] integerValue];
        [cell.content setFrame:CGRectMake(cell.content.frame.origin.x, cell.content.frame.origin.y, cell.contentView.frame.size.width - 10 - cell.forumImg.frame.size.width, height + 10)];
        [cell.content setDelegate:nil];
    }
    else
        [cell.content setDelegate:self];
    
    if (![[dict objectForKey:@"avatar"] isKindOfClass:[NSNull class]])
        [cell.forumImg sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"avatar"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
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
    
    long tag = webView.tag;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[self.commentsArray objectAtIndex:tag]];
    [dict setObject:[NSString stringWithFormat:@"%f", mWebViewFrame.size.height] forKey:@"height"];
    [self.commentsArray replaceObjectAtIndex:tag withObject:dict];

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

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a comment"])
    {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView;
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"Write a comment";
    }
}

@end