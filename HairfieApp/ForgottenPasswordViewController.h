//
//  ForgottenPasswordViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 01/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgottenPasswordViewController : UIViewController <UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic) IBOutlet UIButton *sendButton;
@property (nonatomic) IBOutlet UITextField *emailField;


-(IBAction)goBack:(id)sender;
-(IBAction)getNewPassword:(id)sender;
@end
