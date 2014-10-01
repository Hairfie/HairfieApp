//
//  LoginViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <LoopBack/LoopBack.h>


@interface LoginViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UIButton *noAccountButton;
@property (nonatomic) IBOutlet UIButton *noPasswordButton;
@property (nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic) AppDelegate *delegate;
@property (nonatomic) UITapGestureRecognizer *dismiss;


-(IBAction)doLogin:(id)sender;
-(IBAction)closeKeyboard:(id)sender;
-(IBAction)openEmailField:(id)sender;
-(IBAction)openPasswordField:(id)sender;
-(IBAction)skip:(id)sender;


@end
