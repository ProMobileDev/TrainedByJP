//
//  ForumDetailController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 30/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "ForumDetailController.h"

@interface ForumDetailController ()

@end

@implementation ForumDetailController

-(IBAction)createBtnPressed:(id)sender
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    NSDictionary *params = [UrlManager getCreateForumTopicParameters:self.mainDict title:self.topicTitle.text content:self.topicContent.text tags:self.topicTags.text subscription:self.mNotifOption ? @"1" : @"0"];
    
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
             [Utilities alertDisplay:APP_NAME message:[dict objectForKey:RESPONSE_KEY_MESSAGE] controller:self];
         }
         
         [self.myTable reloadData];
         
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

-(IBAction)cancelBtnPressed:(id)sender
{
    [self.createView setHidden:YES];
}

-(IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)createTopicBtnPressed:(id)sender
{
    [self.createView setHidden:NO];
}

-(void) callApi
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:[UrlManager getForumDetailParameters:self.mainDict] progress:^(NSProgress * _Nonnull uploadProgress) {
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
             if (![[[dict objectForKey:@"forum"] objectForKey:@"topics"] isKindOfClass:[NSNull class]])
                 self.topicsArray = [[dict objectForKey:@"forum"] objectForKey:@"topics"];
             
             self.mainDict = [dict objectForKey:@"forum"];
             
             if (![[self.mainDict objectForKey:@"subscribed"] boolValue])
                 [self.mSubscribeBtn setTitle:@"+ Subscribe to this forum for updates" forState:UIControlStateNormal];
             else
                 [self.mSubscribeBtn setTitle:@"- Unsubscribe from this forum" forState:UIControlStateNormal];
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
        params =  [UrlManager getSubscribeForumDetailParameters:self.mainDict subscribe:@"1"];
    }
    else
    {
        subscribed = @"0";
        params =  [UrlManager getUnSubscribeForumDetailParameters:self.mainDict];
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
             [self.mSubscribeBtn setTitle:@"+ Subscribe to this forum for updates" forState:UIControlStateNormal];
         else
             [self.mSubscribeBtn setTitle:@"- Unsubscribe from this forum" forState:UIControlStateNormal];
         
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
    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_DETAIL_TOPIC] animated:YES];
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
    
    cell.titleText.text  = [topic objectForKey:@"topic_title"];
    cell.timeText.text   = [topic objectForKey:@"last_update"];
    
    cell.postsText.text  = [NSString stringWithFormat:@"%ld", [[topic objectForKey:@"total_posts"] integerValue]];
    cell.voicesText.text = [NSString stringWithFormat:@"%ld", [[topic objectForKey:@"total_voice"] integerValue]];
    
    return cell;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainDict = [[NSMutableDictionary alloc] initWithDictionary:[ApiManager sharedInstance].selectedDict];
    
    self.titleText.text = [self.mainDict objectForKey:@"forum_title"];
    
    self.topicsArray = [[NSMutableArray alloc] init];
    [self callApi];
    [self.createView setHidden:YES];
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
