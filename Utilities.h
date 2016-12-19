//
//  Utilities.h
//
//  Created by Muh@mm@d Um@R on 1/31/13.
//  Copyright (c) 2013 Nawab Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "Constants.h"

@interface Utilities : NSObject

+(UIStoryboard *) getStoryBoard;
+(NSString *) getFontAppliedHTMLString:(NSString *)string;

+(BOOL) NSStringIsValidEmail:(NSString *)checkString;

+(void) errorDisplay:(NSString *)error controller:(UIViewController *)ctrl;
+(void) alertDisplay:(NSString* )title message:(NSString *)message controller:(UIViewController *)ctrl;
+(void) alertDisplayWithButton:(NSString* )title message:(NSString *)message button:(NSString *)button controller:(UIViewController *)ctrl;
+ (NSDate*)getLocalDateTimeFromString:(NSString*)dayString;


@end
