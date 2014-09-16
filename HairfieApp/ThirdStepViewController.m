//
//  ThirdStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ThirdStepViewController.h"

@interface ThirdStepViewController ()

@end

@implementation ThirdStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *addressPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    UIView *postalPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    UIView *cityPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    
    
    _address.layer.cornerRadius =5;
    _address.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _address.layer.borderWidth = 1;
    _address.leftView = addressPadding;
    _address.leftViewMode = UITextFieldViewModeAlways;
    
    _city.layer.cornerRadius =5;
    _city.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _city.layer.borderWidth = 1;
    _city.leftView = postalPadding;
    _city.leftViewMode = UITextFieldViewModeAlways;
    
    _postalCode.layer.cornerRadius =5;
    _postalCode.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _postalCode.layer.borderWidth = 1;
    _postalCode.leftView = cityPadding;
    _postalCode.leftViewMode = UITextFieldViewModeAlways;
    
    _currentAddressBttn.layer.cornerRadius =5;
    _currentAddressBttn.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _currentAddressBttn.layer.borderWidth = 1;
    
    
    // Do any additional setup after loading the view.
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

        NSLog(@"cool");
    }
    return YES;
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
