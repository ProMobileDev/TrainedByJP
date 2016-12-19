//
//  VideosController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 26/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "VideosController.h"
#import "ReceipeCellModel.h"

@interface VideosController ()

@end

@implementation VideosController

-(void)callApi
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    NSDictionary *params = [UrlManager getVideoAlbums];
    
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
             self.articlesArray = [dict objectForKey:@"albums"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self callApi];
    [self callHome];
}

-(void)callHome
{
    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_HOME] animated:NO];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *topic = [self.articlesArray objectAtIndex:indexPath.row];
    [ApiManager sharedInstance].selectedDict = topic;
    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_DETAIL_VIDEO] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articlesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"ReceipeCell";
    ReceipeCellModel *cell = [self.myTable dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
    
    NSDictionary *topic = [self.articlesArray objectAtIndex:indexPath.row];
    
    if ([[topic objectForKey:@"cover"] isKindOfClass:[NSNull class]])
        return cell;
    
    [cell.receipeImg sd_setImageWithURL:[NSURL URLWithString:[topic objectForKey:@"cover"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
     }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.receipeText.text = [topic objectForKey:@"title"];
    
    return cell;
}

@end