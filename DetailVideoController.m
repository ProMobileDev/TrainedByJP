//
//  DetailVideoController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 31/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "DetailVideoController.h"
#import "ReceipeCellModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoCommentController.h"

@interface DetailVideoController ()

@end

@implementation DetailVideoController

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)callApi
{
    NSDictionary *params = [UrlManager getAlbumParameters:currentPageIndex album:[self.mainDict objectForKey:@"id"]];
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         [self.myTable.pullToRefreshView stopAnimating];
         [self.myTable.infiniteScrollingView stopAnimating];
         
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
             dict = [dict objectForKey:@"album"];
             
             if ([[dict objectForKey:@"videos"] isKindOfClass:[NSNull class]])
                 return;
             
             NSMutableArray *mainDict = [dict objectForKey:@"videos"];
             
             if (currentPageIndex == 1)
                 self.workoutsArray = [[NSMutableArray alloc] init];
             
             NSMutableArray *couponMainList = [[NSMutableArray alloc] init];
             
             for (int i = 0; i < mainDict.count; i++)
             {
                 [couponMainList addObject:[mainDict objectAtIndex:i]];
             }
             
             if (currentPageIndex < [[dict objectForKey:@"total_pages"] longLongValue])
                 currentPageIndex++;
             else
             {
                 [self.myTable setShowsInfiniteScrolling:NO];
                 shouldLoadMore = NO;
             }
             
             for (int i = 0; i < couponMainList.count; i++)
             {
                 [self.workoutsArray addObject:[couponMainList objectAtIndex:i]];
             }
         }
         [self.myTable reloadData];
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [self.myTable.pullToRefreshView     stopAnimating];
         [self.myTable.infiniteScrollingView stopAnimating];
     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainDict = [ApiManager sharedInstance].selectedDict;
    
    currentPageIndex = 1;
    shouldLoadMore = YES;
    
    [self.titleText setText:[self.mainDict objectForKey:@"title"]];
    
    [self.myTable addPullToRefreshWithActionHandler:^{
        
        currentPageIndex = 1;
        shouldLoadMore = YES;
        [self.myTable setShowsInfiniteScrolling:YES];
        [self callApi];
        
    }];
    
    [self.myTable addInfiniteScrollingWithActionHandler:^{
        
        [self callApi];
        
    }];
    
    self.myTable.pullToRefreshView.arrowColor = [UIColor colorWithRed:239.0/255.0f green:239/255.0f blue:244/255.0f alpha:1];
    [self callApi];
    [self.myTable.infiniteScrollingView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *topic = [self.workoutsArray objectAtIndex:indexPath.row];
    [ApiManager sharedInstance].url = [topic objectForKey:@"video_link_secure"];
    
    MPMoviePlayerViewController *moviePlayerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[ApiManager sharedInstance].url]];
    
    moviePlayerVC.view.transform = CGAffineTransformIdentity;
    moviePlayerVC.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    
    
    moviePlayerVC.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    moviePlayerVC.moviePlayer.fullscreen = YES;
    
    [self presentViewController:moviePlayerVC animated:NO completion:NULL];
    
    
//    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_VIDEO] animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.workoutsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"ReceipeCell";
    ReceipeCellModel *cell = [self.myTable dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
    
    NSDictionary *topic = [self.workoutsArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentCount.text = [topic objectForKey:@"comments"];
    cell.commentBtn.tag = [indexPath row];
    [cell.commentBtn addTarget:self action:@selector(openComments:) forControlEvents:UIControlEventTouchUpInside];
    cell.receipeText.text = [topic objectForKey:@"title"];
    [cell.receipeImg sd_setImageWithURL:[NSURL URLWithString:[topic objectForKey:@"cover_link_with_play_button"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
     }];
    
    return cell;
}

-(void) openComments:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    NSDictionary *topic = [self.workoutsArray objectAtIndex:tag];
    
    VideoCommentController *detail = (VideoCommentController *) [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_VIDEO_COMMENT];
    detail.mainDict = [[NSMutableDictionary alloc] initWithDictionary:topic];
    
    self.definesPresentationContext = YES; //self is presenting view controller
    detail.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9f];
    detail.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [self presentViewController:detail animated:YES completion:nil];
}


@end
