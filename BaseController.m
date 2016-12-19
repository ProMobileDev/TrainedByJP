//
//  BaseController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 27/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

-(IBAction)homeBtnPressed:(id)sender
{
    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_HOME] animated:YES];
}

-(IBAction)logoutBtnPressed:(id)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:APP_NAME
                                  message:@"Are you sure you want to logout?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [Prefrences removeUserDefaults];
                             AppDelegate *app = ((AppDelegate *) [[UIApplication sharedApplication] delegate]);
                             UINavigationController *mCtrl = (UINavigationController *) app.window.rootViewController;
                             
                             NSMutableArray *newViewControllers = [NSMutableArray array];
                             [newViewControllers addObject:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_LOGIN]];
                             [mCtrl setViewControllers:newViewControllers animated:YES];
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

-(void)logoutViaUnAuthorization
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:APP_NAME
                                  message:@"Your authentication token has been expired. Please login again"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             [Prefrences removeUserDefaults];
                                                          
                             AppDelegate *app = ((AppDelegate *) [[UIApplication sharedApplication] delegate]);
                             UINavigationController *mCtrl = (UINavigationController *) app.window.rootViewController;
                             
                             NSMutableArray *newViewControllers = [NSMutableArray array];
                             [newViewControllers addObject:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_LOGIN]];
                             [mCtrl setViewControllers:newViewControllers animated:YES];
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPressed:) name:@"topicRecieved" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)pushPressed:(NSNotification *)notif
{
    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_DETAIL_TOPIC] animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end