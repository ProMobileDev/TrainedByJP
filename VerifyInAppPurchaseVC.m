//
//  VerifyInAppPurchaseVC.m
//  TrainedByJP
//
//  Created by Rahish Kansal on 29/09/16.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import "VerifyInAppPurchaseVC.h"
#import "IAPHandler.h"

@interface VerifyInAppPurchaseVC ()<IAPHandlerDelegate>


@end

@implementation VerifyInAppPurchaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self validateSubscription];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//MARK:- UIContolrEvent Handlers
- (IBAction)subscribeBtnAction:(id)sender
{
    IAPHandler *iapHandler = [IAPHandler sharedInstance];
    [iapHandler setDelegate:self];
    [iapHandler sendProductRequest];
}

- (IBAction)restoreBtnAction:(id)sender
{
    IAPHandler *iapHandler = [IAPHandler sharedInstance];
    [iapHandler setDelegate:self];
    [iapHandler reStoreTransaction];
}


-(IBAction)validateSubscription
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.label.text = @"Validating Subscription...";
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    
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
    
    [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
        
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
                [self sendReceiptInfoOnServerToVerify:[responseData[@"latest_receipt_info"] lastObject]];
            }
        }
    }];
}

-(void)sendReceiptInfoOnServerToVerify:(NSDictionary *)receiptInfo
{
    //If error from server then
    //show the Buttons on the Viewcontoller
    //else navigate to
    
    //navCtrl = [[UINavigationController alloc] initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_MAIN]];
}


//MARK: IAPHandlerDelegate Methods
-(void)responseAfterInAppPurchase:(SKPaymentTransaction*)transaction andProgressHUD:(MBProgressHUD *)progressHUD
{
    //On Success
    
    //navCtrl = [[UINavigationController alloc] initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:IDENTIFIER_MAIN]];
    
    //TODO: On Failure
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _subcribeVw.hidden = NO;
        _restoreVw.hidden = NO;
        _retryValidationsVW.hidden = NO;
        _iapDescriptionLbl.hidden = NO;
    });
    
}
     

@end
