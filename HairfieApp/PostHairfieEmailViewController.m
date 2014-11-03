//
//  PostHairfieEmailViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/3/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "PostHairfieEmailViewController.h"

@interface PostHairfieEmailViewController ()

@end

@implementation PostHairfieEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerTitle.text = NSLocalizedStringFromTable(@"email hairfie", @"Post_Hairfie", nil);
    
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.emailField becomeFirstResponder];
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
        [nextResponder resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
