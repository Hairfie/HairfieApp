//
//  SuggestHairdresserViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 10/21/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SuggestHairdresserViewController.h"

@interface SuggestHairdresserViewController ()

@end

@implementation SuggestHairdresserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _firstNameView.layer.cornerRadius = 5;
    _firstNameView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _firstNameView.layer.borderWidth = 1;
    _lastNameView.layer.cornerRadius = 5;
    _lastNameView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _lastNameView.layer.borderWidth = 1;
    _submitBttn.layer.cornerRadius = 5;
    [_submitBttn setTitle:NSLocalizedStringFromTable(@"Submit", @"BusinessErrorReport", nil) forState:UIControlStateNormal];
    _headerTitle.text = NSLocalizedStringFromTable(@"Suggest hairdresser", @"SuggestHairdresser", nil);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
