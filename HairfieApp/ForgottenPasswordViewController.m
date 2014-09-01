//
//  ForgottenPasswordViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 01/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ForgottenPasswordViewController.h"

@interface ForgottenPasswordViewController ()
{
    UIActivityIndicatorView *spinner;
}
@end

@implementation ForgottenPasswordViewController

@synthesize sendButton, emailField;

- (void)viewDidLoad {
    [super viewDidLoad];
    sendButton.layer.cornerRadius = 5;
    sendButton.layer.masksToBounds = YES;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setFrame:CGRectMake(150, self.view.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height)];
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [spinner stopAnimating];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getNewPassword:self];
    return YES;
}

-(IBAction)getNewPassword:(id)sender
{
    NSString *emailToRecover = emailField.text;
    NSLog(@"Gimme pw of %@", emailToRecover);
   
    // spinner doesnt stop no back-end, stops when editing field
    [spinner startAnimating];

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
