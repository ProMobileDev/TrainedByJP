//
//  IAPHandler.h
//  SnowInstructor
//
//  Created by Kansal on 04/11/14.
//  Copyright (c) 2014 intersoft. All rights reserved.
//
/***************In-App Purchase is handled in this Class*************/

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol IAPHandlerDelegate <NSObject>

@required

-(void)responseAfterInAppPurchase:(SKPaymentTransaction*)transaction andProgressHUD:(MBProgressHUD *)progressHUD;

@end

@interface IAPHandler : NSObject<SKProductsRequestDelegate, SKRequestDelegate,SKPaymentTransactionObserver>
{
    MBProgressHUD *progressHUD;
}

@property(nonatomic, strong)id<IAPHandlerDelegate>delegate;

+ (IAPHandler *)sharedInstance;

// Send product Request
-(void)sendProductRequest;

-(void)reStoreTransaction;

@end
