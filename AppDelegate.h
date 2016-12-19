//
//  AppDelegate.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 22/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDictionary *launchOptionsOnStart;

@property (nonatomic) BOOL isVideoController;
@property (nonatomic) BOOL shouldCallPush;

@property (nonatomic, strong) NSString *topicId;

@end

