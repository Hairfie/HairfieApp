//
//  SignUpViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageSetPicker.h"

@interface SignUpViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIWebViewDelegate, ImageSetPickerDelegate>

@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UIButton *signUpButton;
@property (nonatomic) IBOutlet UIButton *statusBarButton;
@property (nonatomic) IBOutlet UIView *infoView;
@property (nonatomic) IBOutlet UIView *titleView;
@property (nonatomic) IBOutlet UIButton *titleButton;
@property (nonatomic) IBOutlet UILabel *userTitleLabel;
@property (nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic) IBOutlet UIButton *checkBoxButton;
@property (nonatomic) BOOL isNewsletterChecked;
@property (nonatomic) IBOutlet UIButton *addPictureButton;
@property (nonatomic) IBOutlet UILabel *addPictureLabel;
@property (nonatomic) IBOutlet UIImageView *profilePicture;

@property (nonatomic) IBOutlet UITextField *firstNameField;
@property (nonatomic) IBOutlet UITextField *lastNameField;
@property (nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic) IBOutlet UITextField *titleField;
@property (nonatomic) UITapGestureRecognizer *dismiss;
@property (nonatomic) IBOutlet UIPickerView *userTitle;

-(IBAction)goBack:(id)sender;
-(IBAction)checkBox:(id)sender;
-(IBAction)showTitlePicker:(id)sender;

@end
