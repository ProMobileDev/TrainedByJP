//
//  Prefrences.m
//  CityTaxi
//
//  Created by Muhammad Umar on 18/10/2015.
//  Copyright © 2015 DeviceBee Technologies. All rights reserved.
//

#import "Prefrences.h"
#import "Constants.h"

@implementation Prefrences

+(BOOL) isUserLoggedIn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:USERDEFAULT_ISLOGGEDIN];
}

+(void) saveUserDefaultsForDict:(NSDictionary *)dict
{
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error == nil)
    {
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
        [Prefrences saveDefaultForKey:USERDEFAULT_USER obj:jsonStr];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERDEFAULT_ISLOGGEDIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(void) removeUserDefaults
{
    [Prefrences saveDefaultForKey:USERDEFAULT_USER obj:@""];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USERDEFAULT_ISLOGGEDIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) saveDefaultForKey:(NSString *)key obj:(NSString *)obj
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[Prefrences scramble:obj] forKey:key];
    [defaults synchronize];
}

+(NSString *) getDefaultForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [Prefrences deScramble:[defaults stringForKey:key]];
}


#pragma mark - Scramble

//This is really just a light security system when storing in nsuserdefaults locally

+(NSString*)scramble:(NSString*)string {
    
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@""];

    NSInteger randomPrefeix = arc4random() % 90000 + 10000;
    NSString *prefix = [NSString stringWithFormat:@"%lu", (long)randomPrefeix];
    
    NSInteger randomSuffix = arc4random() % 90000 + 10000;
    NSString *suffix = [NSString stringWithFormat:@"%lu", (long)randomSuffix];
    
    
    string = [prefix stringByAppendingString:string];
    string = [string stringByAppendingString:suffix];
    
    
    NSMutableData *data = [[NSMutableData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len); //this is an array of bytes
    memcpy(byteData, [data bytes], len);
    
    NSInteger i = 0;
    while (i < len) {
        if (byteData[i] > 0)
            byteData[i] = byteData[i] - 1;
        i++;
    }
    
    NSData *data2 = [[NSData alloc] initWithBytes:byteData length:len];
    NSString *cryptStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
    
    
    free(byteData);
    
    //NSLog(@"Encrypted: %@", cryptStr);
    return cryptStr;
    
}


+(NSString*)deScramble:(NSString*)string
{    
    if (!string) {
        return nil;
    }
    
    NSMutableData *data = [[NSMutableData alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSUInteger len = [data length];
    Byte *byteData = (Byte*)malloc(len); //this is an array of bytes
    memcpy(byteData, [data bytes], len);
    
    NSInteger i = 0;
    while (i < len) {
        if (byteData[i] > 0)
            byteData[i] = byteData[i] + 1;
        i++;
    }
    
    NSData *data2 = [[NSData alloc] initWithBytes:byteData length:len];
    NSString *cryptStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
    
    
    cryptStr = [cryptStr substringWithRange:NSMakeRange(5, cryptStr.length - 10)];
    
    free(byteData);
    
    //NSLog(@"Decrypted: %@", cryptStr);
    return cryptStr;
    
}

@end
