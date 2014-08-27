//
//  SignUpViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlayView.h"

@interface SignUpViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic) IBOutlet UIButton *statusBarButton;
@property (nonatomic) IBOutlet UIView *infoView;
@property (nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic) IBOutlet UIButton *checkBoxButton;
@property (nonatomic) BOOL isChecked;

@property (nonatomic) IBOutlet UITextField *firstNameField;
@property (nonatomic) IBOutlet UITextField *lastNameField;
@property (nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic) IBOutlet UITextField *titleField;
@property (nonatomic) UITapGestureRecognizer *dismiss;
@property (nonatomic) CameraOverlayView *camera;

-(IBAction)goBack:(id)sender;
-(IBAction)checkBox:(id)sender;

@end
