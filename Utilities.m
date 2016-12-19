//
//  Utilities.m
//
//  Created by Muh@mm@d Um@R on 1/31/13.
//  Copyright (c) 2013 Nawab Enterprises. All rights reserved.
//

#import "Utilities.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Utilities

+(NSString *) getFontAppliedHTMLString:(NSString *)string
{
    UIFont *font = [UIFont systemFontOfSize:13.0f weight:UIFontWeightSemibold];
    NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %i\">%@</span>",
                  @"HelveticaNeue",
                  (int) font.pointSize,
                  string];
    return htmlString;
}


+(UIStoryboard *) getStoryBoard;
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return [UIStoryboard storyboardWithName:@"Main_iPad" bundle: nil];
    else
        return [UIStoryboard storyboardWithName:@"Main" bundle: nil];
}

+(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (NSDate*)getLocalDateTimeFromString:(NSString*)dayString
{
    //2014-09-18 14:13:04
    dayString = [dayString stringByReplacingOccurrencesOfString:@".000Z" withString:@""];
    dayString = [dayString stringByReplacingOccurrencesOfString:@"T" withString:@" "];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSDate *someDateInUTC = [dateFormatter dateFromString:dayString];
    
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *text = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
    
    return text;
}

+(void) errorDisplay:(NSString *)error controller:(UIViewController *)ctrl
{
    NSString *errorText = [NSString stringWithFormat:@"%@ %@",@"An error has occurred.",error ];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Oops!"
                                  message:errorText
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                        }];
    
    [alert addAction:ok];

    [ctrl presentViewController:alert animated:YES completion:nil];
}

+(void) alertDisplay:(NSString* )title message:(NSString *)message controller:(UIViewController *)ctrl
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];

    [alert addAction:ok];
    [ctrl presentViewController:alert animated:YES completion:nil];
}

+(void) alertDisplayWithButton:(NSString* )title message:(NSString *)message button:(NSString *)button
 controller:(UIViewController *)ctrl
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:button
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    [ctrl presentViewController:alert animated:YES completion:nil];
}

+(void)clearCookiesAndCache
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cook in storage.cookies)
    {
        [storage deleteCookie:cook];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSLog(@"Cleared cookies and cache");
}

@end