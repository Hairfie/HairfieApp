//
//  FinalStepAddressViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepAddressViewController.h"

@interface FinalStepAddressViewController ()

@end

@implementation FinalStepAddressViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *addressPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];

    _address.layer.cornerRadius =5;
    _address.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _address.layer.borderWidth = 1;
    _address.leftView = addressPadding;
    _address.leftViewMode = UITextFieldViewModeAlways;
    
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
    
    // Do any additional setup after loading the view.
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
