//
//  SignUpVC.h
//  TrainedByJP
//
//  Created by Rahish Kansal on 27/09/16.
//  Copyright © 2016 Neberox Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *firstNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passWrdTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTxtFld;

@end
