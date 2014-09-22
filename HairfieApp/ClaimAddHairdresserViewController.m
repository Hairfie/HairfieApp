//
//  ClaimAddHairdresserViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ClaimAddHairdresserViewController.h"

@interface ClaimAddHairdresserViewController ()

@end

@implementation ClaimAddHairdresserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    _doneBttn.layer.cornerRadius = 5;
    _doneBttn.layer.masksToBounds = YES;

    
    // Do any additional setup after loading the view.
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
