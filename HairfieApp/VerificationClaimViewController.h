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

@interface VerificationClaimViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UILabel *civilityLabel;
@property (nonatomic) IBOutlet UITextField *firstNameField;
@property (nonatomic) IBOutlet UITextField *lastNameField;
@property (nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic) IBOutlet UITextField *phoneField;

@property (nonatomic) IBOutlet UIView *titleView;
@property (nonatomic) IBOutlet UIButton *titleButton;
@property (nonatomic) IBOutlet UIPickerView *userTitle;

-(IBAction)validateVerification:(id)sender;

@end
