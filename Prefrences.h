//
//  Prefrences.h
//  CityTaxi
//
//  Created by Muhammad Umar on 18/10/2015.
//  Copyright © 2015 DeviceBee Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prefrences : NSObject

+(BOOL) isUserLoggedIn;


+(void) saveUserDefaultsForDict:(NSString *)dict;
+(void) removeUserDefaults;

+(void) saveDefaultForKey:(NSString *)key obj:(NSString *)obj;
+(NSString *) getDefaultForKey:(NSString *)key;

@end
