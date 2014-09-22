//
//  VerificationClaimViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "VerificationClaimViewController.h"

@interface VerificationClaimViewController ()

@end

@implementation VerificationClaimViewController
{
    AppDelegate *delegate;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
   
    if ([delegate.currentUser.gender isEqualToString:@"male"])
        _civilityField.text = @"Homme";
    else
        _civilityField.text = @"Femme";
    
    _firstNameField.text = delegate.currentUser.firstName;
    _lastNameField.text = delegate.currentUser.lastName;
    _emailField.text = delegate.currentUser.email;
    _phoneField.text = delegate.currentUser.phoneNumber;
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    // Do any additional setup after loading the view.
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
