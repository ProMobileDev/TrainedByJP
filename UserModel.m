//
//  UserModel.m
//  CityTaxi
//
//  Created by Muhammad Umar on 18/10/2015.
//  Copyright © 2015 DeviceBee Technologies. All rights reserved.
//

#import "UserModel.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "Prefrences.h"

@implementation UserModel

+(UserModel *)initWithCurrentDeviceValues
{
    UserModel *user = [[UserModel alloc] init];
    
    if ([Prefrences isUserLoggedIn])
    {
        NSString *jsonStr = [Prefrences getDefaultForKey:USERDEFAULT_USER];
        NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        
        user.userId     = [dict objectForKey:@"id"];
        user.userLogin  = [dict objectForKey:@"user_login"];
        user.authKey    = [dict objectForKey:@"auth_key"];
        user.email      = [dict objectForKey:@"email"];
        user.displayName = [dict objectForKey:@"display_name"];
        
        user.email       = [dict objectForKey:@"user_email"];
        user.niceName       = [dict objectForKey:@"user_nicename"];
    }
    else
    {
        user.userId = @"0";
    }
    
    
    NSString *osVersion = [NSString stringWithFormat:@"%@ %@",
                           [[UIDevice currentDevice] systemName],
                           [[UIDevice currentDevice] systemVersion]];
    
    size_t size = 100;
    char *hw_machine = malloc(size);
    int nameDev[] = {CTL_HW,HW_MACHINE};
    sysctl(nameDev, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    
    user.deviceType = DEVICE_TYPE;
    user.osVersion = osVersion;
    user.deviceModel = hardware;

    return user;
}

-(NSURL *)getProfileImgUrl
{
    NSString *imgPath = [NSString stringWithFormat:@"%@/profile_images/%@", BASE_URL, @""];
    return [NSURL URLWithString:imgPath];
}


@end
