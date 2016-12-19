//
//  ReceipeController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 24/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "ReceipeController.h"
#import "ReceipeCellModel.h"

@interface ReceipeController ()

@end

@implementation ReceipeController

-(void)callApi
{
    MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    indicator.mode = MBProgressHUDModeIndeterminate;
    indicator.label.text = @"Please wait...";
    
    NSDictionary *params = [UrlManager getCategoryParameters:19];
    
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
             self.receipesArray = [dict objectForKey:@"posts"];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.view.frame.size.height > 568)
        return 300.0f;
    else
        return 220.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.receipesArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [ApiManager sharedInstance].selectedDict = [self.receipesArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_DETAIL] animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myIdentifier = @"ReceipeCell";
    ReceipeCellModel *cell = [self.myTable dequeueReusableCellWithIdentifier:myIdentifier forIndexPath:indexPath];
    
    NSDictionary *topic = [self.receipesArray objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.authorName.text  = [topic objectForKey:@"author"];
    cell.receipeText.text = [topic objectForKey:@"post_title"];
    cell.timeText.text    = [topic objectForKey:@"date"];
    
    [cell.miniIndicator startAnimating];
    [cell.maxIndicator startAnimating];
    
    [cell.authorImg sd_setImageWithURL:[NSURL URLWithString:[topic objectForKey:@"author_avatar"]] placeholderImage:[UIImage imageNamed:@""]];    
    
    [cell.receipeImg sd_setImageWithURL:[NSURL URLWithString:[topic objectForKey:@"featured_image"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        if (error)
        {

        }
        
    }];
    
    UIView *receipeNameLbl = [cell.contentView viewWithTag:1100];
    
    if (receipeNameLbl)
        [cell.contentView bringSubviewToFront:receipeNameLbl];
    
    return cell;
}

@end
