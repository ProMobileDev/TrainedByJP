//
//  UserModel.h
//  CityTaxi
//
//  Created by Muhammad Umar on 18/10/2015.
//  Copyright © 2015 DeviceBee Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userLogin;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *niceName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *authKey;

@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *osVersion;
@property (nonatomic, strong) NSString *deviceModel;
@property (nonatomic, strong) NSString *deviceToken;

+(UserModel *)initWithCurrentDeviceValues;
-(NSURL *)getProfileImgUrl;

@end
