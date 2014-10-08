//
//  ClaimAddHairdresserViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ClaimAddHairdresserViewController.h"
#import "FinalStepViewController.h"

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

    _phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
    [self addDoneButtonToPriceField];
    
    _doneBttn.layer.cornerRadius = 5;
    _doneBttn.layer.masksToBounds = YES;

    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    if (_hairdressersClaimed != nil)
        hairdressers = _hairdressersClaimed;
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


-(void)addHairdresser
{
    Hairdresser *hairdresser = [[Hairdresser alloc] init];
    
    hairdresser.firstName = _firstNameField.text;
    hairdresser.lastName = _lastNameField.text;
    hairdresser.email = _emailField.text;
    hairdresser.phoneNumber = _phoneNumberField.text;
    
    [hairdressers addObject:hairdresser];
}

-(IBAction)validateHairdresser:(id)sender
{
    // TO DO enregistrer les coiffeurs ajoutés
    [self addHairdresser];
    FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    
    if (finalStep.businessToManage != nil)
        finalStep.businessToManage.hairdressers = hairdressers;
    else
        finalStep.claim.hairdressers = hairdressers;
     [self goBack:self];
}

// WTF COPIER COLLER LOL

-(void) addDoneButtonToPriceField {
    
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barTintColor = [UIColor salonDetailTab];
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Validate phone", @"Claim", nil)
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(doneClicked:)];
    doneButton.tintColor = [UIColor whiteColor];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 90;
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:fixedSpace,doneButton, nil]];
    
    _phoneNumberField.inputAccessoryView = keyboardDoneButtonView;
}

-(IBAction)doneClicked:(id)sender
{
    [_phoneNumberField resignFirstResponder];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
