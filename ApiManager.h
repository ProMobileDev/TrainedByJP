//
//  ApiManager.h
//  CityTaxi
//
//  Created by Muhammad Umar on 18/10/2015.
//  Copyright © 2015 DeviceBee Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "AFHTTPSessionManager.h"

@interface ApiManager : NSObject

@property (nonatomic, strong) UserModel *myUser;

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSDictionary *selectedDict;

+ (ApiManager *)sharedInstance;

@end
