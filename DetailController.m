//
//  DetailController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 26/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "DetailController.h"
#import "ForumCellModel.h"

@interface DetailController ()
{
    UITextField *mCommentBox;
    float mScrollHeight;
}
@end

@implementation DetailController

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)postCommentBtnPressed:(id)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Post Comment"
                                  message:@"Please Enter Comment"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField)
    {
        mCommentBox = textField;
    }];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];                             
                             if (![mCommentBox.text isEqualToString:@""])
                             {
                                 [self addComment];
                             }
                         }];
    
    [alert addAction:ok];
    
    UIAlertAction* cancel = [UIAlertAction
                         actionWithTitle:@"Cancel"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) addComment
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:[UrlManager addComment:mCommentBox.text parent:@"" dict:self.mainDict] progress:^(NSProgress * _Nonnull uploadProgress) {
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
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [indicator hideAnimated:YES];
         
         if (error)
         {
             [Utilities errorDisplay:error.localizedDescription controller:self];
         }
         
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainDict = [ApiManager sharedInstance].selectedDict;
    
    mScrollHeight = 1.0f;    
    self.commentsArray = [[NSMutableArray alloc] init];

    [self.titleText setText:[self.mainDict objectForKey:@"post_title"]];
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
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:[UrlManager getDetailParameters:self.mainDict] progress:^(NSProgress * _Nonnull uploadProgress) {
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
             self.htmlString = [Utilities getFontAppliedHTMLString:[[dict objectForKey:@"post"] objectForKey:@"content"]];
             if (![[[dict objectForKey:@"post"] objectForKey:@"comments"] isKindOfClass:[NSNull class]])
                 self.commentsArray = [[dict objectForKey:@"post"] objectForKey:@"comments"];
         }
         
         [self.mTable reloadData];
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
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
        NSDictionary *dict = [self.commentsArray objectAtIndex:indexPath.row];
        
        CGRect size = [[dict objectForKey:@"comment_content"] boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 40, MAXFLOAT)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:attributes
                                                                         context:nil];
        
        if (size.size.height > 30)
        {
            CGFloat mSize = 65 + size.size.height;
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
        UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, self.view.frame.size.width, 30)];
        [mLabel setTextColor:[UIColor blackColor]];
         mView  = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];

        if (self.commentsArray.count != 0)
            [mLabel setText:@"COMMENTS"];
    
        [mLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [mView setBackgroundColor:[UIColor clearColor]];
        [mView addSubview:mLabel];
        
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

        cell.titleText.text = [dict objectForKey:@"comment_author"];
        cell.timeText.text  = [dict objectForKey:@"comment_date"];
        cell.comment.text   = [dict objectForKey:@"comment_content"];
        
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
    mScrollHeight = mWebViewFrame.size.height;
    
    //Disable bouncing in webview
    for (id subview in webView.subviews) {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
            [subview setBounces:NO];
        }
    }
    [webView setUserInteractionEnabled:NO];
    [self.mTable reloadData];
}


@end
