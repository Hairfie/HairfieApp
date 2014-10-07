//
//  FinalStepAddressViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepAddressViewController.h"
#import "FinalStepViewController.h"

@interface FinalStepAddressViewController ()

@end

@implementation FinalStepAddressViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _street.text = _address.street;
    _city.text = _address.city;
    _country.text = _address.country;
    
    UIView *streetPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];

    
    _street.leftView = streetPadding;
    _street.leftViewMode = UITextFieldViewModeAlways;

    _street.layer.cornerRadius =5;
    _street.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _street.layer.borderWidth = 1;
    
    
    _street.leftView = streetPadding;
    _street.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *cityPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    
    _city.layer.cornerRadius =5;
    _city.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _city.layer.borderWidth = 1;
    _city.leftView = cityPadding;
    _city.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *countryPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    
    _country.layer.cornerRadius =5;
    _country.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _country.layer.borderWidth = 1;
    _country.leftView = countryPadding;
    _country.leftViewMode = UITextFieldViewModeAlways;

     _doneBttn.layer.cornerRadius = 5;
    
    
    [_street becomeFirstResponder];
    // Do any additional setup after loading the view.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [self validateAddress:self];
        [textField resignFirstResponder];
    }
    return YES;
}


-(IBAction)validateAddress:(id)sender
{
    // TO DO enregistrer l'adresse modifiée
    
    FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    
    
    if (finalStep.businessToManage != nil)
    {
        finalStep.businessToManage.address.street = _street.text;
        finalStep.businessToManage.address.city = _city.text;
        finalStep.businessToManage.address.country = _country.text;
    }
    else
    {
    
    finalStep.claim.address.street = _street.text;
    finalStep.claim.address.city = _city.text;
    finalStep.claim.address.country = _country.text;
    }
    [self goBack:self];
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
