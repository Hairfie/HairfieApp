//
//  ClaimAddHairdresserViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ClaimAddHairdresserViewController.h"
#import "FinalStepViewController.h"
#import "UITextField+Style.h"

@interface ClaimAddHairdresserViewController ()

@end

@implementation ClaimAddHairdresserViewController
{
    NSMutableArray *hairdressers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hairdressers = [[NSMutableArray alloc] init];
    
    _firstNameView.layer.cornerRadius = 5;
    _firstNameView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _firstNameView.layer.borderWidth = 1;
    
    _lastNameView.layer.cornerRadius = 5;
    _lastNameView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _lastNameView.layer.borderWidth = 1;

    _emailView.layer.cornerRadius = 5;
    _emailView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _emailView.layer.borderWidth = 1;

    _phoneNumberView.layer.cornerRadius = 5;
    _phoneNumberView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _phoneNumberView.layer.borderWidth = 1;

    [_phoneNumberField textFieldWithPhoneKeyboard];
    
    _doneBttn.layer.cornerRadius = 5;
    _doneBttn.layer.masksToBounds = YES;

    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    if (_hairdressersClaimed != nil) {
        hairdressers = _hairdressersClaimed;
    }

    if (_hairdresserFromSegue != nil)
    {
        _firstNameField.text = _hairdresserFromSegue.firstName;
         _lastNameField.text = _hairdresserFromSegue.lastName;
         _emailField.text = _hairdresserFromSegue.email;
         _phoneNumberField.text = _hairdresserFromSegue.phoneNumber;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self validateHairdresser:self];
        //[textField resignFirstResponder];
    }
    return YES;
}

-(void)addHairdresserWithBusiness:(Business *)aBusiness
{
    Hairdresser *hairdresser = [[Hairdresser alloc] init];
    hairdresser.business = aBusiness;
    hairdresser.active = YES;
    hairdresser.firstName = _firstNameField.text;
    hairdresser.lastName = _lastNameField.text;
    hairdresser.email = _emailField.text;
    hairdresser.phoneNumber = _phoneNumberField.text;
   
    if (_hairdresserFromSegue.id != nil)
    {
        hairdresser.id = _hairdresserFromSegue.id;
    }
    
    
    
   
    [hairdressers addObject:hairdresser];
    NSLog(@"hairdressers %@", hairdresser);
    [hairdresser saveWithSuccess:^() { NSLog(@"Hairdresser saved"); }
                         failure:^(NSError *error) {
                             NSLog(@"Failed to save hairdresser: %@", error.localizedDescription);
                         }];
}

-(IBAction)validateHairdresser:(id)sender
{
    // TO DO enregistrer les coiffeurs ajoutés
    FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]; // TODO: c'est pas super beau...
    
    [self addHairdresserWithBusiness:finalStep.businessToManage];

    if (finalStep.businessToManage != nil) {
        finalStep.businessToManage.activeHairdressers = hairdressers;
    } else {
        finalStep.claim.hairdressers = hairdressers;
    }

    [self goBack:self];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
