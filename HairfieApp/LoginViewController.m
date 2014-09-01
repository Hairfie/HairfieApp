//
//  LoginViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "AppDelegate.h"
#import "CredentialStore.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _noAccountButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _noAccountButton.layer.borderWidth = 0.5;
    _noAccountButton.backgroundColor = [UIColor clearColor];
    _noAccountButton.layer.cornerRadius = 5;
    _noAccountButton.layer.masksToBounds = YES;
    _delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTextFields)];
   
    if ([_delegate.credentialStore isLoggedIn])
    {
        [AppDelegate lbAdaptater].accessToken = [_delegate.credentialStore authToken];
        
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    }
    
    [self.view addGestureRecognizer:_dismiss];
    // Do any additional setup after loading the view.
}

-(void) dismissTextFields
{
    [_passwordField resignFirstResponder];
    [_emailField resignFirstResponder];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
        [self doLogin:self];
        [self.view removeGestureRecognizer:_dismiss];
    }
    return YES;
}

-(IBAction)doLogin:(id)sender
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error on load %ld", error.code);
        if (error.code == -1011) {
            UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"The password in incorrect" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [badLogin show];
        }
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        
        NSDictionary *userData = [results objectForKey:@"user"];
        
        // Connected User Data
        
        _delegate.currentUser.userToken = [results objectForKey:@"id"];
        _delegate.currentUser.userId = [results objectForKey:@"userId"];
        _delegate.currentUser.name = [NSString stringWithFormat:@"%@ %@",[userData objectForKey:@"firstName"], [userData objectForKey:@"lastName"]];
        _delegate.currentUser.imageLink = [userData objectForKey:@"picture"];
        
        // Access Token
        
        [AppDelegate lbAdaptater].accessToken = [results objectForKey:@"id"];
        [_delegate.credentialStore setAuthToken:[results objectForKey:@"id"]];
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    };
    
    if ([self isValidEmail: _emailField.text]) {
        
        NSString *repoName = @"users";
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/login?include=user" verb:@"POST"] forMethod:@"users.login"];
        
        LBModelRepository *loginData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
        [loginData invokeStaticMethod:@"login" parameters:@{@"email": _emailField.text, @"password" : _passwordField.text} success:loadSuccessBlock failure:loadErrorBlock];
    } else {
        UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"The email/password in incorrect" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [badLogin show];
    }
}


-(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
