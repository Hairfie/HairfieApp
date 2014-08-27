//
//  LoginViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UIButton *noAccountButton;
@property (nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic) IBOutlet UITextField *passwordField;

-(IBAction)doLogin:(id)sender;

@end
