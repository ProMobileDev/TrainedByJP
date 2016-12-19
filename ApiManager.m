//
//  ApiManager.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 18/10/2015.
//  Copyright © 2015 DeviceBee Technologies. All rights reserved.
//

#import "ApiManager.h"

@implementation ApiManager

@synthesize myUser;

static ApiManager *sharedInstance = nil;
static dispatch_once_t onceToken;

+ (ApiManager *)sharedInstance
{
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[ApiManager alloc] init];
        
        sharedInstance.myUser  = [UserModel initWithCurrentDeviceValues];
        sharedInstance.manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        
        sharedInstance.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return sharedInstance;
}


@end