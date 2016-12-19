//
//  BaseController.h
//  TrainedByJP
//
//  Created by Muhammad Umar on 27/07/2016.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController

-(void)logoutViaUnAuthorization;
-(IBAction)homeBtnPressed:(id)sender;
-(void)pushPressed:(NSNotification *)notif;

@end
