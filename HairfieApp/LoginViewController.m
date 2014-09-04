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
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()
@end

@implementation LoginViewController {
    UserAuthenticator *userAuthenticator;
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


    if ([_delegate.credentialStore isLoggedIn])
    {
         [AppDelegate lbAdaptater].accessToken = [_delegate.credentialStore authToken];
        
        [userAuthenticator getCurrentUser];
        
        
        //_delegate.currentUser = auth.getCurrentUser;
        
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
}


-(IBAction)getFacebookUserInfoOld:(id)sender
{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierFacebook];
    
    
    NSDictionary *options = @{@"ACFacebookAppIdKey" : FB_APP_ID,
                              @"ACFacebookPermissionsKey" : FB_SCOPE};
    
    [account requestAccessToAccountsWithType:accountType
                                     options:options
                                  completion:^(BOOL granted, NSError *error)
    {
        
       
        if (granted == YES)
        {
            NSLog(@"go to login ");
            NSArray *accounts = [account accountsWithAccountType:accountType];
            ACAccount *fbAccount = [[ACAccount alloc] init];
            fbAccount = [accounts lastObject];
            ACAccountCredential *fbCredential = [fbAccount credential];
            NSString *fbAuthToken = [fbCredential oauthToken];
            [self loginWithFbToken:fbAuthToken];
        }
    }];
}

- (IBAction)getFacebookUserInfo:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        //[self userLoggedIn];
        FBAccessTokenData *accessTokenData = [session accessTokenData];
        NSString *fbAuthToken = [accessTokenData accessToken];
        [self loginWithFbToken:fbAuthToken];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}


-(void)loginWithFbToken:(NSString*)fbAuthToken
{
    LBRESTAdapter *fbLbAdaptater = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://api.staging.hairfie.com/"]];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error on load %@", error.description);
    };
    
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        
        [AppDelegate lbAdaptater].accessToken = [results objectForKey:@"id"];
        [_delegate.credentialStore setAuthTokenAndUserId:[results objectForKey:@"id"] forUser:[results objectForKey:@"userId"]];
        [userAuthenticator getCurrentUser];

        [self performSegueWithIdentifier:@"loginSuccess" sender:self];
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
