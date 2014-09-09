//
//  LoginViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 26/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "UserRepository.h"
#import "UserAuthenticator.h"
#import "HairfieRequest.h"
#import "AppDelegate.h"
#import "CredentialStore.h"
#import "MenuViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UITextField+ELFixSecureTextFieldFont.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()
@end

@implementation LoginViewController {
    UserAuthenticator *userAuthenticator;
    HairfieRequest *hairfieRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];

     _noAccountButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _noAccountButton.layer.borderWidth = 0.5;
    _noAccountButton.backgroundColor = [UIColor clearColor];
    _noAccountButton.layer.cornerRadius = 5;
    _noAccountButton.layer.masksToBounds = YES;
    _delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTextFields)];
    userAuthenticator = [[UserAuthenticator alloc] init];
    hairfieRequest = [[HairfieRequest alloc] init];
    [_passwordField fixSecureTextFieldFont];
    if ([_delegate.credentialStore isLoggedIn])
    {
         [AppDelegate lbAdaptater].accessToken = [_delegate.credentialStore authToken];
        
        [userAuthenticator getCurrentUser];
        
        
        //_delegate.currentUser = auth.getCurrentUser;
        
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    }

    [self.view addGestureRecognizer:_dismiss];
    
    // Login without prompting anything if you have a FB session
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                       allowLoginUI:NO
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    // Do any additional setup after loading the view.
}

-(void) dismissTextFields
{
    [_passwordField resignFirstResponder];
    [_emailField resignFirstResponder];
    _noPasswordButton.hidden = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
        if (textField == _passwordField)
        {
         
            _noPasswordButton.hidden = YES;
        }
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _passwordField)
    {
        
        _noPasswordButton.hidden = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        _noPasswordButton.hidden = YES;
        [nextResponder becomeFirstResponder];
    } else {
        [self doLogin:self];
        _noPasswordButton.hidden = NO;
        [self.view removeGestureRecognizer:_dismiss];
    }
    return YES;
}

-(IBAction)doLogin:(id)sender
{
    [self.view endEditing:YES];
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error on load %zd", error.code);
        if (error.code == -1011) {
            UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"The password in incorrect" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [badLogin show];
        }
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {

        [_delegate.credentialStore setAuthTokenAndUserId:[results objectForKey:@"id"] forUser:[results objectForKey:@"userId"]];
        [AppDelegate lbAdaptater].accessToken = [results objectForKey:@"id"];
        
        [userAuthenticator getCurrentUser];
        [self dismissTextFields];
        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    };

    if ([self isValidEmail: _emailField.text]) {

        NSString *repoName = @"users";
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/login" verb:@"POST"] forMethod:@"users.login"];

        LBModelRepository *loginData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
        [loginData invokeStaticMethod:@"login" parameters:@{@"email": _emailField.text, @"password" : _passwordField.text} success:loadSuccessBlock failure:loadErrorBlock];
    } else {
        UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"The email/password in incorrect" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [badLogin show];
    }
}

-(IBAction)closeKeyboard:(id)sender {
    [self.view endEditing:YES];
     _noPasswordButton.hidden = NO;

}

-(IBAction)openEmailField:(id)sender {
    [_emailField becomeFirstResponder];
}

-(IBAction)openPasswordField:(id)sender {
    [_passwordField becomeFirstResponder];
}


- (IBAction)getFacebookUserInfo:(id)sender
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [self sessionStateChanged:FBSession.activeSession state:FBSession.activeSession.state error:nil];
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        FBAccessTokenData *accessTokenData = [session accessTokenData];
        NSString *fbAuthToken = [accessTokenData accessToken];
        [self loginWithFbToken:fbAuthToken];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        NSLog(@"Session closed");
    }

    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;

        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
            } else {
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}


-(void)loginWithFbToken:(NSString*)fbAuthToken
{
    LBRESTAdapter *fbLbAdaptater = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://api.staging.hairfie.com/"]];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error on load %@", error.description);
    };
    
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        BOOL performLogin = ![_delegate.credentialStore isLoggedIn];
        [AppDelegate lbAdaptater].accessToken = [results objectForKey:@"id"];
        [_delegate.credentialStore setAuthTokenAndUserId:[results objectForKey:@"id"] forUser:[results objectForKey:@"userId"]];
        [userAuthenticator getCurrentUser];
        if(performLogin)    [self performSegueWithIdentifier:@"loginSuccess" sender:self];
    };

    NSString *repoName = @"auth/facebook/token";

    [[fbLbAdaptater contract] addItem:[SLRESTContractItem itemWithPattern:@"" verb:@"POST"] forMethod:@"facebook.login"];
    
    LBModelRepository *loginData = [fbLbAdaptater repositoryWithModelName:repoName];

    [loginData invokeStaticMethod:@"" parameters:@{@"access_token":fbAuthToken} success:loadSuccessBlock failure:loadErrorBlock];
}

- (void) showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
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
