//
//  TabController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 24/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "TabController.h"
#import "VideosController.h"

@interface TabController ()

@end

@implementation TabController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setTintColor:[UIColor colorWithRed:57.0/255.0 green:98.0/255.0 blue:152.0/255.0 alpha:1]];
    
    [self setDelegate:self];
    [self callApiForPush];
}

-(void) homePressed:(NSNotification *)notif
{
    UINavigationController *mNavCtrl = (UINavigationController *)[[self viewControllers] objectAtIndex:0];
    [mNavCtrl popToRootViewControllerAnimated:YES];
    [self setSelectedIndex:0];
     VideosController *mCtrl = (VideosController *)[[mNavCtrl viewControllers] objectAtIndex:0];
    [mCtrl callHome];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homePressed:) name:@"homePushRecieved" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
    UINavigationController *mainCtrl = (UINavigationController *) viewController;
    [mainCtrl popToRootViewControllerAnimated:NO];
}

-(void)callApiForPush
{
    NSDictionary *params = [UrlManager getPushParams];
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"%@", error.localizedDescription);
     }];

}

@end
