//
//  ForumsController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 25/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "ForumsController.h"
#import "ForumCellModel.h"

@interface ForumsController ()

@end

@implementation ForumsController

-(void) callApi
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:[UrlManager getForumParameters] progress:^(NSProgress * _Nonnull uploadProgress) {
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
             if (![[dict objectForKey:@"forums"] isKindOfClass:[NSNull class]])
                 self.topicsArray = [dict objectForKey:@"forums"];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [ApiManager sharedInstance].selectedDict = [self.topicsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_DETAIL_FORUM] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topicsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"ForumsCell";
    ForumCellModel *cell = [self.myTable dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
    
    NSDictionary *topic = [self.topicsArray objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.titleText.text  = [topic objectForKey:@"forum_title"];
    cell.timeText.text   = [topic objectForKey:@"last_update"];
    
    cell.postsText.text  = [NSString stringWithFormat:@"%ld", [[topic objectForKey:@"forum_topics"] integerValue]];
    cell.voicesText.text = [NSString stringWithFormat:@"%ld", [[topic objectForKey:@"topics_posts"] integerValue]];
        
    if (![[topic objectForKey:@"featured_image"] isKindOfClass:[NSNull class]])
        [cell.forumImg sd_setImageWithURL:[NSURL URLWithString:[topic objectForKey:@"featured_image"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {}];
    
    return cell;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.topicsArray = [[NSMutableArray alloc] init];
    [self callApi];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end