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
    NSMutableArray *businessMembers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.topBarView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];

    businessMembers = [[NSMutableArray alloc] init];
    
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

    [_phoneNumberField textFieldWithPhoneKeyboard:(self.view.frame.size.width / 2 - 50)];
    
    _doneBttn.layer.cornerRadius = 5;
    _doneBttn.layer.masksToBounds = YES;

    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    if (self.claimedBusinessMembers != nil) {
        businessMembers = self.claimedBusinessMembers;
    }
    
    if (self.businessMemberFromSegue != nil) {
        self.firstNameField.text = self.businessMemberFromSegue.firstName;
        self.lastNameField.text = self.businessMemberFromSegue.firstName;
        self.emailField.text = (![self.businessMemberFromSegue.email isEqual:(id)[NSNull null]]) ? self.businessMemberFromSegue.email : @"";
         self.phoneNumberField.text = (![self.businessMemberFromSegue.phoneNumber isEqual:(id)[NSNull null]]) ? self.businessMemberFromSegue.phoneNumber : @"";
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
    BusinessMember *businessMember = [[BusinessMember alloc] init];
    businessMember.business = aBusiness;
    businessMember.active = YES;
    businessMember.firstName = self.firstNameField.text;
    businessMember.lastName = self.lastNameField.text;
    businessMember.email = self.emailField.text;
    businessMember.phoneNumber = self.phoneNumberField.text;
   
    if (self.businessMemberFromSegue.id != nil)
    {
        businessMember.id = self.businessMemberFromSegue.id;
    }
    
    [businessMembers addObject:businessMember];
    NSLog(@"businessMembers %@", businessMembers);
    [businessMember saveWithSuccess:^() {
                        NSLog(@"Business member successfully saved");
                    }
                            failure:^(NSError *error) {
                                NSLog(@"Failed to save business member: %@", error.localizedDescription);
                            }];
}

-(IBAction)validateHairdresser:(id)sender
{
    // TO DO enregistrer les coiffeurs ajoutés
    FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2]; // TODO: c'est pas super beau...
    
    [self addHairdresserWithBusiness:finalStep.businessToManage];

    if (finalStep.businessToManage != nil) {
        finalStep.businessToManage.activeHairdressers = businessMembers;
    }
    [self goBack:self];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
