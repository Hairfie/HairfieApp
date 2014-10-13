//
//  SecondStepSalonPhoneViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SecondStepSalonPhoneViewController.h"
#import "SecondStepViewController.h"
#import "FinalStepViewController.h"
#import "UITextField+Style.h"

@interface SecondStepSalonPhoneViewController ()

@end

@implementation SecondStepSalonPhoneViewController

@synthesize headerTitle, headerLabel,textFieldPlaceHolder, textField, textFieldFromSegue;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValidated:) name:@"validateTextField" object:nil];
    
    headerLabel.text = headerTitle;
    textField.placeholder = textFieldPlaceHolder;
   
    UIView *fieldPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    if (_isExisting == YES)
    {
        textField.text = textFieldFromSegue;
    }
    if (_isSalon == NO)
    {
        [textField textFieldWithPhoneKeyboard];
    }
    textField.layer.cornerRadius =5;
    textField.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    textField.layer.borderWidth = 1;
    textField.leftView = fieldPadding;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeyDone;
    _doneBttn.layer.cornerRadius = 5;
    [textField becomeFirstResponder];
    // Do any additional setup after loading the view.
}

-(BOOL)textFieldShouldReturn:(UITextField *)_textField
{
    [_textField resignFirstResponder];
    
    return YES;
}



- (void)textFieldValidated:(NSNotification *)notification
{
    
    if (_isFinalStep == NO){
        SecondStepViewController *claim = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        
        if (_isSalon == NO)
        {
            claim.isPhoneSet = YES;
            claim.phoneTextField.text = textField.text;
        }
        else
        {
            claim.isSalonSet = YES;
            claim.salonTextField.text = textField.text;
        }
    }
    else
    {
        FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        
        if (finalStep.businessToManage != nil) {
            if (_isSalon == NO) {
                finalStep.businessToManage.phoneNumber = textField.text;
            } else {
                finalStep.businessToManage.name = textField.text;
            }
        } else {
            if (_isSalon == NO) {
                finalStep.claim.phoneNumber = textField.text;
            } else {
                finalStep.claim.name = textField.text;
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}



-(IBAction)goBack:(id)sender
{
    [self textFieldValidated:nil];
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
