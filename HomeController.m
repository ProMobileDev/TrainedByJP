//
//  HomeController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 24/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "HomeController.h"

@interface HomeController ()
{
    BOOL pageControlBeingUsed;
    int currentPage;
}
@end

@implementation HomeController

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) callApi
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:[UrlManager getHomeParameters] progress:^(NSProgress * _Nonnull uploadProgress) {
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

         if ([[dict objectForKey:RESPONSE_KEY_SUCCESS] integerValue] == -1)
         {
             [self logoutViaUnAuthorization];
             return;
         }
         
         if (![[dict objectForKey:RESPONSE_KEY_SUCCESS] boolValue])
         {
             [Utilities errorDisplay:[dict objectForKey:RESPONSE_KEY_MESSAGE] controller:self];
         }
         else
         {
             if (![[dict objectForKey:@"latest_videos"] isKindOfClass:[NSNull class]])
                 self.videosArray = [dict objectForKey:@"latest_videos"];
             if (![[dict objectForKey:@"topics"] isKindOfClass:[NSNull class]])
                self.topicsArray = [dict objectForKey:@"topics"];
             if (![[dict objectForKey:@"total_topics"] isKindOfClass:[NSNull class]])
                 self.totalTopics = [[dict objectForKey:@"total_topics"] integerValue];
         }
         
         [self.myTable reloadData];
         
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
        return 30.0;
    else
        return 60.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (self.view.frame.size.height > 700)
            return 270.0f;
        else if (self.view.frame.size.height > 568)
            return 250.0f;
        else if (self.view.frame.size.height > 480)
            return 220.0;
        else
            return 200.0;
    }
    else
        return 100.0;
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
        return [self.topicsArray count];
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *mView;
    UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 30)];
    [mLabel setTextColor:[UIColor whiteColor]];

    if (section == 0)
    {
         mView  = [[UIView alloc]  initWithFrame:CGRectMake(12, 0, self.view.frame.size.width, 30)];
        [mLabel setText:@"LATEST VIDEOS"];
    }
    else
    {
         mView  = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
        [mLabel setText:@"FORUMS"];
         UILabel *latestLbl  = [[UILabel alloc]  initWithFrame:CGRectMake(10, 30, self.view.frame.size.width, 30)];
        [latestLbl setText:@"TRAINING LOGS"];
        [latestLbl setTextColor:[UIColor lightGrayColor]];
        [latestLbl setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [mView addSubview:latestLbl];
        
        
        UILabel *countLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 110, 0, 100, 30)];
        [countLbl setText:[NSString stringWithFormat:@"%ld Topics", self.totalTopics]];
        [countLbl setTextColor:[UIColor blackColor]];
        [countLbl setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [mView addSubview:countLbl];
    }

    UIView *bgView = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [bgView setBackgroundColor:[UIColor colorWithRed:56.0/255.0 green:84.0/255.0 blue:121.0/255.0 alpha:1]];
    [mView addSubview:bgView];

    [mLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [mView setBackgroundColor:[UIColor whiteColor]];
    [mView addSubview:mLabel];
    return mView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0)
        return;
    
    [ApiManager sharedInstance].selectedDict = [self.topicsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_DETAIL_TOPIC] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        static NSString *myIdentifier = @"ForumsCell";
        ForumCellModel *cell = [self.myTable dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *topic = [self.topicsArray objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleText.text  = [topic objectForKey:@"topic_title"];
        cell.timeText.text   = [topic objectForKey:@"last_update"];

        cell.postsText.text  = [NSString stringWithFormat:@"%ld", [[topic objectForKey:@"total_posts"] integerValue]];
        cell.voicesText.text = [NSString stringWithFormat:@"%ld", [[topic objectForKey:@"total_voice"] integerValue]];
        
        return cell;
    }
    else
    {
        static NSString *myIdentifier = @"VideoCell";
        ForumCellModel *cell = [self.myTable dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.mScrollView setBackgroundColor:[UIColor whiteColor]];
        
        for(UIView *view in cell.mScrollView.subviews)
            [view removeFromSuperview];
        
        for (int x = 0; x < self.videosArray.count; x++)
        {
            CGRect frame;
            frame.origin.x = cell.mScrollView.frame.size.width * x;
            frame.origin.y = 0;
            frame.size = cell.mScrollView.frame.size;
            
            NSMutableDictionary *videoDict = [self.videosArray objectAtIndex:x];
            UIView *myView = [[UIView alloc] initWithFrame:frame];
            myView.backgroundColor = [UIColor whiteColor];
            
            UIImageView* imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            
            imgView.frame = CGRectMake(5, -10, myView.frame.size.width - 10, myView.frame.size.height - 20);
            [imgView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
            [imgView.layer setBorderWidth: 2.0];
            [myView addSubview:imgView];
            
            UIView *mView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.mScrollView.frame.size.height - 40, cell.mScrollView.frame.size.width, 40)];
            [mView setBackgroundColor:[UIColor blackColor]];
            [mView setAlpha:0.4];
            [myView addSubview:mView];
            
            UILabel *mLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, cell.mScrollView.frame.size.height - 43, cell.mScrollView.frame.size.width, 30)];
            [mLabel setBackgroundColor:[UIColor clearColor]];
            [mLabel setTextColor:[UIColor whiteColor]];
            [mLabel setText:[videoDict objectForKey:@"title"]];
            [myView addSubview:mLabel];
            
            [cell.mScrollView addSubview:myView];
            
            [imgView sd_setImageWithURL:[videoDict objectForKey:@"cover_link_with_play_button"] placeholderImage:[UIImage imageNamed:@"placeholderMap.png"]];
            
            myView.tag = x;
            
            UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoBtnPressed:)];
            [myView addGestureRecognizer:mTap];
        }
        
        if(self.mTimer != nil)
           [self.mTimer invalidate];
        
        self.mTimer = [NSTimer scheduledTimerWithTimeInterval:1.5
                                          target:self
                                        selector:@selector(scrollPages)
                                        userInfo:Nil
                                         repeats:YES];
        
        cell.mScrollView.contentSize = CGSizeMake(cell.mScrollView.frame.size.width * self.videosArray.count, cell.mScrollView.frame.size.height);
        cell.mPageControl.numberOfPages = self.videosArray.count;
        cell.mPageControl.currentPage = 0;
        [cell.mScrollView setPagingEnabled:YES];
        [cell.mScrollView setDelegate:self];
        self.videoCell = cell;

        return cell;
    }
}

-(void)videoBtnPressed:(UITapGestureRecognizer *) sender
{
    UIView *view = sender.view;

    NSDictionary *videoDict = [self.videosArray objectAtIndex:view.tag];
    [ApiManager sharedInstance].url = [videoDict objectForKey:@"video_link_secure"];

    MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[ApiManager sharedInstance].url]];
    
    moviePlayerVC.view.transform = CGAffineTransformIdentity;
    moviePlayerVC.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    [self presentViewController:moviePlayerVC animated:NO completion:NULL];
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topicsArray = [[NSMutableArray alloc] init];
    self.videosArray = [[NSMutableArray alloc] init];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (app.shouldCallPush)
    {
        app.shouldCallPush = NO;
        [self pushPressed:nil];
    }
    
    [self callApi];
    
    currentPage = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
        CGFloat pageWidth = self.videoCell.mScrollView.frame.size.width;
        int page = floor((self.videoCell.mScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.videoCell.mPageControl.currentPage = page;
        currentPage = page;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}

-(void)scrollPages
{
    if (self.videosArray.count == 0)
        return;
    
    [self scrollToPage:currentPage % self.videosArray.count];
    currentPage++;
    if (currentPage >= self.videosArray.count)
        currentPage = 0;
}

-(void)scrollToPage:(NSInteger)aPage
{
    float myPageWidth = [self.videoCell.mScrollView frame].size.width;
    [self.videoCell.mScrollView setContentOffset:CGPointMake(aPage * myPageWidth, 0) animated:YES];
}

@end