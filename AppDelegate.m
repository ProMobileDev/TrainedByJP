//
//  AppDelegate.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 22/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "AppDelegate.h"
#import "VideoController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize launchOptionsOnStart;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if(DEBUG)
        NSLog(@"DEBug Mode");
    else
        NSLog(@"Release");
    
    self.isVideoController = NO;
    
    UIUserNotificationType allNotificationTypes = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UINavigationController *navCtrl;
    UIStoryboard *storyboard = [Utilities getStoryBoard];
    self.shouldCallPush = NO;

    if ([Prefrences isUserLoggedIn])
    {
        navCtrl = [[UINavigationController alloc] initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_MAIN]];
    }
    else
    {
        navCtrl = [[UINavigationController alloc] initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_LOGIN]];
    }
    
    launchOptionsOnStart = [[NSDictionary alloc] initWithDictionary:launchOptions];
    
    if(launchOptionsOnStart != nil)
    {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil)
        {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            NSString *copoun = [[userInfo objectForKey:@"aps"] objectForKey:@"topic_id"];
            if (copoun != nil)
            {
                if (![copoun isKindOfClass:[NSNull class]])
                {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:copoun forKey:@"topic_id"];
                    [ApiManager sharedInstance].selectedDict = dict;
                
                    self.shouldCallPush = YES;
                
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"topicRecieved" object:nil userInfo:userInfo];
                }
                else
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"homePushRecieved" object:nil userInfo:userInfo];
            }
        }
    }
    
    [navCtrl setNavigationBarHidden:YES];    
    self.window.rootViewController = navCtrl;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.isVideoController)
    {
        return UIInterfaceOrientationMaskAll;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    NSMutableString *string = [[NSMutableString alloc]init];
    long length = [token length];
    char const *bytes = [token bytes];
    for (int i=0; i< length; i++)
    {
        [string appendString:[NSString stringWithFormat:@"%02.2hhx",bytes[i]]];
    }
    
    NSLog(@"Device Token String: %@",string);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:USERDEFAULT_TOKEN];
    [defaults synchronize];
    
    if (![Prefrences isUserLoggedIn])
        return;
    
    NSDictionary *params = [UrlManager getPushParams];
    
    [[ApiManager sharedInstance].manager POST:BASE_URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
     }];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (userInfo != nil)
    {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        NSString *copoun = [[userInfo objectForKey:@"aps"] objectForKey:@"topic_id"];
        if (copoun != nil)
        {
            if ([copoun isKindOfClass:[NSNull class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"homePushRecieved" object:nil userInfo:userInfo];
                return;
            }

            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:copoun forKey:@"topic_id"];
            [ApiManager sharedInstance].selectedDict = dict;
            
            self.shouldCallPush = YES;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"topicRecieved" object:nil userInfo:userInfo];
        }
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:@"homePushRecieved" object:nil userInfo:userInfo];
    }
}

@end