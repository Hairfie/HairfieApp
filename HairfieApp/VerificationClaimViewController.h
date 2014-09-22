//
//  VerificationClaimViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"

@interface VerificationClaimViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic) IBOutlet UITextField *civilityField;
@property (nonatomic) IBOutlet UITextField *firstNameField;
@property (nonatomic) IBOutlet UITextField *lastNameField;
@property (nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic) IBOutlet UITextField *phoneField;


@end
