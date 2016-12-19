//
//  SignUpVC.m
//  TrainedByJP
//
//  Created by Rahish Kansal on 27/09/16.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "SignUpVC.h"
#import "SafariServices/SafariServices.h"
#import "IAPHandler.h"


#define kTrim(text)     [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

@interface SignUpVC ()<IAPHandlerDelegate>
{
    
}

@end

@implementation SignUpVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark- UIControlEvent Handler
- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpBtnAction:(id)sender
{
    if ([self isAllFieldsValid])
    {
        // Start In-App Purchase
        [_emailTxtFld resignFirstResponder];
        
        MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        indicator.mode = MBProgressHUDModeIndeterminate;
        indicator.label.text = @"Verifying email...";
        
        NSString *url = [UrlManager registrationURL];
        
        NSDictionary *params = [UrlManager emailValidation:kTrim(_emailTxtFld.text)];
        
        [[ApiManager sharedInstance].manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             [indicator hideAnimated:YES];
             
             NSError *error = nil;
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&error];
             
             if (error)
             {
                 [Utilities errorDisplay:@"Unable to parse response from server" controller:self];
             }
             else
             {
                 if (![[dict objectForKey:RESPONSE_KEY_SUCCESS] boolValue])
                 {
                     //In-App Purchase
                     
                     IAPHandler *iapHandler = [IAPHandler sharedInstance];
                     [iapHandler setDelegate:self];
                     [iapHandler sendProductRequest];
                 }
                 else
                 {
                     [Utilities errorDisplay:[dict objectForKey:RESPONSE_KEY_MESSAGE] controller:self];
                 }
             }
             
             
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             [indicator hideAnimated:YES];
             
             if (error)
             {
                 [Utilities errorDisplay:error.localizedDescription controller:self];
             }
             
         }];
    }
}

-(BOOL)isAllFieldsValid
{
    NSString *firstNameTxt = kTrim([_firstNameTxtFld text]);
    NSString *lastNameTxt = kTrim([_lastNameTxtFld text]);
    
    NSString *emailTxt = kTrim(_emailTxtFld.text);
    
    NSString *passwordTxt = kTrim([_passWrdTxtFld text]);
    NSString *confirmTxt = kTrim([_confirmPasswordTxtFld text]);
    
    if ([firstNameTxt length] == 0 || [lastNameTxt length] == 0)
    {
        [Utilities alertDisplay:@"Empty Fields!" message:@"First name or last name can't be empty!" controller:self];
    }
    else if (![Utilities NSStringIsValidEmail:emailTxt])
    {
        [Utilities alertDisplay:@"Invalid Email!" message:@"Please enter valid email address!" controller:self];
    }
    else if ([passwordTxt length] == 0)
    {
        [Utilities alertDisplay:@"Empty Password Field!" message:@"Password can't be empty!" controller:self];
    }
    else if (![passwordTxt isEqualToString:confirmTxt])
    {
        [Utilities alertDisplay:nil message:@"Password and Confirm Password should be same!" controller:self];
    }
    else
    {
        return YES;
    }
    
    return NO;
}

//MARK: IAPHandlerDelegate Methods
-(void)responseAfterInAppPurchase:(SKPaymentTransaction*)transaction andProgressHUD:(MBProgressHUD *)progressHUD
{
    NSLog(@"In App Purchase Response == %@",transaction);
    progressHUD.label.text = @"Logging...";
    
    NSString *url = [UrlManager registrationURL];
    
    NSDictionary *params = [UrlManager getSignUpParameterswith:kTrim(_firstNameTxtFld.text) lastName:kTrim(_lastNameTxtFld.text) email:kTrim(_emailTxtFld.text) password:kTrim(_passWrdTxtFld.text) andTransactionID:transaction.transactionIdentifier];
    
    [[ApiManager sharedInstance].manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
            
             [progressHUD hideAnimated:YES];
             
             NSError *error = nil;
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&error];
             
             if (error)
             {
                 [Utilities errorDisplay:@"Unable to parse response from server" controller:self];
                 return ;
             }
             
             if (![[dict objectForKey:RESPONSE_KEY_SUCCESS] boolValue])
             {
                 [Utilities errorDisplay:[dict objectForKey:RESPONSE_KEY_MESSAGE] controller:self];
             }
             else
             {
                 [Prefrences saveUserDefaultsForDict:[dict objectForKey:RESPONSE_KEY_USER]];
                 [ApiManager sharedInstance].myUser = [UserModel initWithCurrentDeviceValues];
                 
                 [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_MAIN] animated:YES];
             }
             
         });
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [progressHUD hideAnimated:YES];
         
         if (error)
         {
             [Utilities errorDisplay:error.localizedDescription controller:self];
         }
         
     }];
}

@end
