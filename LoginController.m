//
//  LoginController.m
//  TrainedByJP
//
//  Created by Muhammad Umar on 24/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "LoginController.h"
#import "SafariServices/SafariServices.h"
#import "IAPHandler.h"

@interface LoginController ()<IAPHandlerDelegate>
{
    NSDictionary *responseDict;
}

@end

@implementation LoginController

- (IBAction)loginBtnPressed:(UIButton *)sender
{    
    if ([[self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0)
    {
        [Utilities errorDisplay:@"Please input valid username" controller:self];
        return;
    }
    else if ([[self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] <= 0)
    {
        [Utilities errorDisplay:@"Please input valid password" controller:self];
        return;
    }
    else
    {
        MBProgressHUD *indicator = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        indicator.mode = MBProgressHUDModeIndeterminate;
        indicator.label.text = @"Logging...";
        
        NSString *url = [UrlManager getLoginUrl];
        
        NSDictionary *params = [UrlManager getLoginParameters:self.username.text password:self.password.text];
        
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
                return ;
            }
            
            if (![[dict objectForKey:RESPONSE_KEY_SUCCESS] boolValue])
            {
                [Utilities errorDisplay:[dict objectForKey:RESPONSE_KEY_MESSAGE] controller:self];
            }
            else
            {
//                [Prefrences saveUserDefaultsForDict:[dict objectForKey:RESPONSE_KEY_USER]];
//                [ApiManager sharedInstance].myUser = [UserModel initWithCurrentDeviceValues];
                
                responseDict = dict;
                
                [self validateSubscription];
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

- (IBAction)signupBtnPressed:(UIButton *)sender
{
    //SFSafariViewController *mCtrl = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:SIGNUP_URL]];
    //[self presentViewController:mCtrl animated:YES completion:nil];
}

- (IBAction)forgotBtnPressed:(UIButton *)sender
{
    SFSafariViewController *mCtrl = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:FORGOT_PASS_URL]];
    [self presentViewController:mCtrl animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.username.text = @"dev.puran";
    //self.password.text = @"^&#Thcvs@78w";

   //self.username.text = @"puran-ios";
   //self.password.text = @"@v!p2o#%xvO5*1Zq@GFU@qkq";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)validateSubscription
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.label.text = @"Validating Subscription...";
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
    if (receiptData != nil || [receiptData length])
    {
        NSDictionary *dict = @{@"receipt-data": [receiptData base64EncodedStringWithOptions:0], @"password":@"4761bc5419ee452e91b3eebd7acd223d"};
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        
        NSString *receiptVerificationURL = @"";
        if(DEBUG)
            receiptVerificationURL = @"https://sandbox.itunes.apple.com/verifyReceipt";
        else
            receiptVerificationURL = @"https://buy.itunes.apple.com/verifyReceipt";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:receiptVerificationURL]];
        [request setHTTPBody:jsonData];
        [request setHTTPMethod:@"POST"];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (connectionError)
                {
                    [progressHUD hideAnimated:YES];
                    [Utilities alertDisplay:@"Subscription validation Failed!" message:[NSString stringWithFormat:@"Subscription validation Failed due to %@",[connectionError localizedDescription]] controller:self];
                }
                else
                {
                    NSError *error;
                    NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                    
                    NSLog(@"responseData  == %@",responseData);
                    
                    if (error)
                    {
                        [progressHUD hideAnimated:YES];
                        
                        [Utilities alertDisplay:@"Subscription validation Failed!" message:[NSString stringWithFormat:@"Subscription validation Failed due to %@",[error localizedDescription]] controller:self];
                    }
                    else
                    {
                        if ([responseData[@"status"] boolValue] == 0)
                        {
                            [Prefrences saveUserDefaultsForDict:[responseDict objectForKey:RESPONSE_KEY_USER]];
                            [ApiManager sharedInstance].myUser = [UserModel initWithCurrentDeviceValues];
                            [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_MAIN] animated:YES];
                        }
                        else
                        {
                            UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Subscription verification Failed!" message:@"Please try again to login or re-subscribe..!" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * action)
                                                 {
                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                     
                                                 }];
                            
                            [alert addAction:ok];
                            
                            UIAlertAction* subscribe = [UIAlertAction actionWithTitle:@"Subscribe" style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action)
                                                        {
                                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                                            
                                                            IAPHandler *iapHandler = [IAPHandler sharedInstance];
                                                            [iapHandler setDelegate:self];
                                                            [iapHandler sendProductRequest];
                                                            
                                                        }];
                            
                            [alert addAction:subscribe];
                            
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    }
                }
            });
            
        }] resume];
    }
    else
    {
        [progressHUD hideAnimated:YES];
        [Prefrences saveUserDefaultsForDict:[responseDict objectForKey:RESPONSE_KEY_USER]];
        [ApiManager sharedInstance].myUser = [UserModel initWithCurrentDeviceValues];
        
        [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_MAIN] animated:YES];
    }
    
}

-(void)responseAfterInAppPurchase:(SKPaymentTransaction*)transaction andProgressHUD:(MBProgressHUD *)progressHUD
{
    [progressHUD hideAnimated:YES];
    [Prefrences saveUserDefaultsForDict:[responseDict objectForKey:RESPONSE_KEY_USER]];
    [ApiManager sharedInstance].myUser = [UserModel initWithCurrentDeviceValues];
    
    [self.navigationController pushViewController:[[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:IDENTIFIER_MAIN] animated:YES];
}

@end
