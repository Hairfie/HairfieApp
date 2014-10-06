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
#import "AppDelegate.h"
#import "CredentialStore.h"
#import "MenuViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UITextField+ELFixSecureTextFieldFont.h"
#import <FacebookSDK/FacebookSDK.h>
#import "HomeViewController.h"
#import "MRProgress.h"
#import "UIButton+Style.h"

@interface LoginViewController ()
@end

@implementation LoginViewController {
    UserAuthenticator *userAuthenticator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_noAccountButton noAccountStyle];
    [_loginButton roundStyle];
    
    _noPasswordButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTextFields)];
    userAuthenticator = [[UserAuthenticator alloc] init];

    [_passwordField fixSecureTextFieldFont];

    if(_doFbConnect) {
        [self fbConnect];
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

-(void) viewWillAppear:(BOOL)animated {
    [ARAnalytics pageView:@"AR - LoginView"];
}

-(void) dismissTextFields {
    [_passwordField resignFirstResponder];
    [_emailField resignFirstResponder];
    _noPasswordButton.hidden = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
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
            UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Login Failed", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"The password in incorrect", @"Login_Sign_Up", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [badLogin show];
        }
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        [_delegate.credentialStore setAuthTokenAndUserId:[results objectForKey:@"id"] forUser:[results objectForKey:@"userId"]];
        [AppDelegate lbAdaptater].accessToken = [results objectForKey:@"id"];
        
        [userAuthenticator getCurrentUser];
        [self dismissTextFields];
        [self performSegueWithIdentifier:@"@Main" sender:self];
    };

    if ([self isValidEmail: _emailField.text]) {

        NSString *repoName = @"users";
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/login" verb:@"POST"] forMethod:@"users.login"];

        LBModelRepository *loginData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
        [loginData invokeStaticMethod:@"login" parameters:@{@"email": _emailField.text, @"password" : _passwordField.text} success:loadSuccessBlock failure:loadErrorBlock];
    } else {
        UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Login Failed", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"The email/password in incorrect", @"Login_Sign_Up", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [badLogin show];
    }
}

-(IBAction)skip:(id)sender {
    [self performSegueWithIdentifier:@"skipLogin" sender:self];
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


- (IBAction)getFacebookUserInfo:(id)sender {
    [self fbConnect];
}

- (void)fbConnect {
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
        [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedStringFromTable(@"Login in progress", @"Login_Sign_Up", nil) mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
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
            alertTitle = NSLocalizedStringFromTable(@"Something went wrong", @"Login_Sign_Up", nil);
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = NSLocalizedStringFromTable(@"Session Error", @"Login_Sign_Up", nil);
                alertText = NSLocalizedStringFromTable(@"Your current session is no longer valid. Please log in again.", @"Login_Sign_Up", nil);
                [self showMessage:alertText withTitle:alertTitle];
            } else {
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = NSLocalizedStringFromTable(@"Something went wrong", @"Login_Sign_Up", nil);
                alertText = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", @"Login_Sign_Up", nil), [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}


-(void)loginWithFbToken:(NSString*)fbAuthToken
{
    LBRESTAdapter *fbLbAdaptater = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:BASE_URL]];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error on load %@", error.description);
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
    };
    
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
        BOOL performLogin = ![_delegate.credentialStore isLoggedIn];
        [AppDelegate lbAdaptater].accessToken = [results objectForKey:@"id"];
        [_delegate.credentialStore setAuthTokenAndUserId:[results objectForKey:@"id"] forUser:[results objectForKey:@"userId"]];
        [userAuthenticator getCurrentUser];
        if(performLogin)    [self performSegueWithIdentifier:@"@Main" sender:self];
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

-(IBAction)goBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"skipLogin"]) {
        [userAuthenticator skipLogin];
    }
}


@end
