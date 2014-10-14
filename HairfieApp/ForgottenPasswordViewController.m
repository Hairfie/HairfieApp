//
//  ForgottenPasswordViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 01/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ForgottenPasswordViewController.h"
#import "AppDelegate.h"

@interface ForgottenPasswordViewController ()
{
    UIActivityIndicatorView *spinner;
    AppDelegate *delegate;
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
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
        [spinner stopAnimating];
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Error", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"Sorry, try again later !", @"Login_Sign_Up", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [errorAlert show];

    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        
        NSLog(@"results %@", results);
        [spinner stopAnimating];
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Success", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"Go check your emails !", @"Login_Sign_Up", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        successAlert.delegate = self;
        [successAlert show];
    };
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/reset" verb:@"POST"] forMethod:@"reset"];
    LBModelRepository *users = [[AppDelegate lbAdaptater] repositoryWithModelName:@"users"];
    
    [users invokeStaticMethod:@"reset" parameters:@{@"email":emailToRecover} success:loadSuccessBlock failure:loadErrorBlock];
   
    // spinner doesnt stop no back-end, stops when editing field
    [spinner startAnimating];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
     [self.navigationController popToRootViewControllerAnimated:YES];
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
