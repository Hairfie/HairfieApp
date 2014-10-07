//
//  ClaimAddHairdresserViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessClaim.h"
#import "Hairdresser.h"

@interface ClaimAddHairdresserViewController : UIViewController <UINavigationControllerDelegate ,UITextFieldDelegate>

@property (nonatomic) IBOutlet UIView* firstNameView;
@property (nonatomic) IBOutlet UIView* lastNameView;
@property (nonatomic) IBOutlet UIView* emailView;
@property (nonatomic) IBOutlet UIView* phoneNumberView;
@property (nonatomic) NSMutableArray *hairdressersClaimed;

@property (nonatomic) IBOutlet UITextField* firstNameField;
@property (nonatomic) IBOutlet UITextField* lastNameField;
@property (nonatomic) IBOutlet UITextField* emailField;
@property (nonatomic) IBOutlet UITextField* phoneNumberField;
@property (nonatomic) Hairdresser *hairdresserFromSegue;

@property (nonatomic) IBOutlet UIButton* doneBttn;


@end
