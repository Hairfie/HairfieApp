//
//  VerificationClaimViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "VerificationClaimViewController.h"
#import "UITextField+Style.h"
#import "NBPhoneMetaData.h"
#import "NBPhoneNumber.h"
#import "NBPhoneNumberDesc.h"
#import "NBPhoneNumberUtil.h"
#import "NBNumberFormat.h"

@interface VerificationClaimViewController ()

@end

@implementation VerificationClaimViewController
{
    AppDelegate *delegate;
    NSArray *title;
    UITapGestureRecognizer *dismissCivility;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValidated:) name:@"validateTextField" object:nil];
    

    NSLog(@"current user %@", [delegate.currentUser toDictionary]);
    
    title = [NSArray arrayWithObjects:NSLocalizedStringFromTable(@"Woman", @"Login_Sign_Up", nil), NSLocalizedStringFromTable(@"Man", @"Login_Sign_Up", nil), nil];
    
    _titleView.hidden = YES;
    [_phoneField textFieldWithPhoneKeyboard];
    
    if ([delegate.currentUser.gender isEqualToString:GENDER_MALE])
    {
        _civilityLabel.text = NSLocalizedStringFromTable(@"Man", @"Claim", nil);
        [_userTitle selectRow:1 inComponent:0 animated:YES];
    }
    else
    {
         _civilityLabel.text = NSLocalizedStringFromTable(@"Women", @"Claim", nil);
        [_userTitle selectRow:0 inComponent:0 animated:YES];
    }
  
    _firstNameField.text = delegate.currentUser.firstName;
    _lastNameField.text = delegate.currentUser.lastName;
    _emailField.text = delegate.currentUser.email;
    if (![delegate.currentUser.phoneNumber isEqual: [NSNull null]])
        _phoneField.text = delegate.currentUser.phoneNumber;
    else
        _phoneField.placeholder = NSLocalizedStringFromTable(@"Add your phone number", @"Claim", nil);
    dismissCivility = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideCivilityPicker)];
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [self showPopup];
}

-(void)hideCivilityPicker
{
    _titleView.hidden = YES;
}

-(void)showPopup {
    
    self.popViewController = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    
    [self.popViewController showInView:self.view withTitle:NSLocalizedStringFromTable(@"You're hairdresser ? Tell Us !", @"Claim", nil) withMessage:NSLocalizedStringFromTable(@"Claim your business in order to manage your business on Hairfie", @"Claim", nil) withButton:NSLocalizedStringFromTable(@"Claim Your Business", @"Claim", nil) animated:YES];
}


-(void) viewWillAppear:(BOOL)animated {
    [ARAnalytics pageView:@"AR - Verification Claim"];
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
        [textField resignFirstResponder];
        
    }
    return YES;
}

- (void)textFieldValidated:(NSNotification *)notification
{
    [self formatPhoneNumber:_phoneField.text];
}
-(void)formatPhoneNumber:(NSString*)phoneNumber
{
    NSLog(@"FORMATING PHONE");
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:phoneNumber
                                 defaultRegion:@"FR" error:&anError];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    if (anError == nil) {
        // Should check error
        if ([phoneUtil isValidNumber:myNumber] == NO)
        {
            alertView.message = NSLocalizedStringFromTable(@"Phone not valid message", @"Claim", nil);
            alertView.title =  NSLocalizedStringFromTable(@"Phone not valid title", @"Claim", nil);;
            [alertView show];
        }
        else
            _phoneField.text = [phoneUtil format:myNumber
                                          numberFormat:NBEPhoneNumberFormatINTERNATIONAL
                                      error:&anError];
      } else {
          NSLog(@"Error : %@", [anError localizedDescription]);
      }
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _firstNameField){
        delegate.currentUser.firstName = _firstNameField.text;
    }
    if (textField == _lastNameField){
        delegate.currentUser.lastName = _lastNameField.text;
    }
    if (textField == _emailField){
        delegate.currentUser.email = _emailField.text;
    }
    if (textField == _phoneField){
        delegate.currentUser.phoneNumber = _phoneField.text;
    }
}

-(IBAction)validateVerification:(id)sender
{
    [self.view endEditing:YES];
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results){
        NSLog(@"USER UPDATED");
        [self performSegueWithIdentifier:@"infoVerified" sender:self];
    };
    
    [delegate.currentUser saveWithSuccess:loadSuccessBlock failure:loadErrorBlock];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Picker Civilite

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return title.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return title[row];
}


-(IBAction)showTitlePicker:(id)sender
{
    [self.view endEditing:YES];
    _titleView.hidden = NO;
    [self.view addGestureRecognizer:dismissCivility];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    _civilityLabel.text = [title objectAtIndex:row];
    [_firstNameField becomeFirstResponder];
    _titleView.hidden = YES;
    if (row == 0){
        delegate.currentUser.gender = GENDER_FEMALE;
    }
    else
        delegate.currentUser.gender = GENDER_MALE
        ;
    [self.view removeGestureRecognizer:dismissCivility];
    [self validateVerification:self];
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
