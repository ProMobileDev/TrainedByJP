//
//  IAPHandler.m
//  SnowInstructor
//
//  Created by Kansal on 04/11/14.
//  Copyright (c) 2014 intersoft. All rights reserved.
//

#import "IAPHandler.h"
#import "AppDelegate.h"

#define kProduct1Month                                 @"com.vw.tbjp.jpmonthlysubscription"

@implementation IAPHandler

/*! Initialize IAP with products Type
 *
 * \param type - selected IAP products
 */

+ (IAPHandler *)sharedInstance
{
    static dispatch_once_t once;
    static IAPHandler * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


#pragma mark1
#pragma mark<Custom Methods>
#pragma mark

// Send product Request
-(void)sendProductRequest
{
    progressHUD = [MBProgressHUD showHUDAddedTo:((UIViewController *)self.delegate).view animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.label.text = @"Loading In-App Products...";
    
    // Initiate instance of SKProductRequest with products identifiers and start request
    SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:kProduct1Month, nil]];
    [productRequest setDelegate:self];
    [productRequest start];
}

//Method Called If user selects Restore Option
-(void)reStoreTransaction
{
    progressHUD = [MBProgressHUD showHUDAddedTo:((UIViewController *)self.delegate).view animated:YES];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.label.text = @"restoring subscription...";
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // restored alredy purchased products(Auto-renewable)
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

// Starts payment for the selected products
-(void)makePaymentForProduct:(SKProduct *)product
{
    // Add product for the payment
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    // add observer for the transaction
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // Add payment in payment Queue
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark
#pragma mark<SKProductRequestDelegate Methods>
#pragma mark

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // Add list of products got in response(if response is not nil)
    if (response != nil && [response products] != nil && [[response products] isKindOfClass:[NSArray class]])
    {
        // Start payment for the selected products
        [self makePaymentForProduct:response.products[0]];
    }
}

- (void)requestDidFinish:(SKRequest *)request
{
    //[UIAppDelegate hideLoading];
}

// Stop processing if product request gets fail due to some error
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [progressHUD hideAnimated:YES];
    [Utilities errorDisplay:@"In-App Purchase failed!" controller:(UIViewController *)self.delegate];
}

#pragma mark
#pragma mark <SKPaymentQueueDelegate Methods>
#pragma mark

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    for(SKPaymentTransaction *transaction in queue.transactions)
    {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    
    //[self.delegate reloadFirstIndex];
}

// Called after Restore State handler
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    [self paymentQueue:queue removedTransactions:queue.transactions];
    
//    for(SKPaymentTransaction *transaction in queue.transactions)
//    {
//        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//        
//        [self.delegate responseAfterInAppPurchase:transaction andProgressHUD:progressHUD];
//    }
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation !" message:@"Restored lives successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alertView show];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        BOOL breakLoop = NO;
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
            {
                progressHUD.label.text = @"Purchasing...";
            }
                break;
                
            case SKPaymentTransactionStatePurchased:
            {
                if ([SKPaymentQueue canMakePayments])
                {
                    //[UIAppDelegate hideLoading];
                    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    
                    NSURL *appURL = [[NSBundle mainBundle] appStoreReceiptURL];
                    
                    if ([[NSFileManager defaultManager] fileExistsAtPath:[appURL path]])
                    {
                        breakLoop = YES;
                        [self receiptValidationForRestoration:NO andTransaction:transaction];
                    }
                }
            }
                break;
                
            case SKPaymentTransactionStateFailed:
            {
                //[UIAppDelegate hideLoading];
                [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [progressHUD hideAnimated:YES];
                [Utilities errorDisplay:@"In-App Purchase failed!" controller:(UIViewController *)self.delegate];
            }
                break;
                
            case SKPaymentTransactionStateRestored:
            {
                //[UIAppDelegate hideLoading];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                NSURL *appURL = [[NSBundle mainBundle] appStoreReceiptURL];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:[appURL path]])
                {
                    [self receiptValidationForRestoration:NO andTransaction:transaction];
                    breakLoop = YES;
                    
                    break;
                }
            }
                break;
                
            default:
                break;
        }
        
        if (breakLoop)
            break;
    }
}

-(void)receiptValidationForRestoration:(BOOL)isInAppRestored andTransaction:(SKPaymentTransaction *)transaction
{
    progressHUD.label.text = @"Validating In-App Purchase...";
    
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
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError) {
        
        if (connectionError)
        {
            [progressHUD hideAnimated:YES];
            
            if (isInAppRestored)
            {
                [Utilities alertDisplay:@"In-App Restoration validation Failed!" message:[NSString stringWithFormat:@"In-App Restoration Failed! due to %@",[connectionError localizedDescription]] controller:(UIViewController *)self.delegate];
            }
            else
            {
                [Utilities alertDisplay:@"In-App purchase validation Failed!" message:[NSString stringWithFormat:@"In-App Purchase Validation Failed! due to %@",[connectionError localizedDescription]] controller:(UIViewController *)self.delegate];
            }
        }
        else
        {
            NSError *error;
            NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSLog(@"responseData  == %@",responseData);
            
            if (error)
            {
                [progressHUD hideAnimated:YES];
                
                if (isInAppRestored)
                {
                    [Utilities alertDisplay:@"In-App Restoration validation Failed!" message:[NSString stringWithFormat:@"In-App Restoration Failed! due to %@",[connectionError localizedDescription]] controller:(UIViewController *)self.delegate];
                }
                else
                {
                    [Utilities alertDisplay:@"In-App purchase validation Failed!" message:[NSString stringWithFormat:@"In-App Purchase Validation Failed! due to %@",[connectionError localizedDescription]] controller:(UIViewController *)self.delegate];
                }
            }
            else
            {
                [self.delegate responseAfterInAppPurchase:transaction andProgressHUD:progressHUD];
            }
        }

    }] resume];

}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
