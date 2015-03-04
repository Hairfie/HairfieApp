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
#import "FBAuthenticator.h"

@interface LoginViewController ()
@end

@implementation LoginViewController {
    UserAuthenticator *userAuthenticator;
    FBAuthenticator *fbAuthenticator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_noAccountButton noAccountStyle];
    [_loginButton roundStyle];
    
    _noPasswordButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _delegate           = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _dismiss            = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTextFields)];
    userAuthenticator   = [[UserAuthenticator alloc] init];
    fbAuthenticator     = [[FBAuthenticator alloc] init];

    [_passwordField fixSecureTextFieldFont];

    if(_doFbConnect) {
        [self fbConnect];
    }

    [self.view addGestureRecognizer:_dismiss];
    
    // Login without prompting anything if you have a FB session
//    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
//                                       allowLoginUI:NO
//                                  completionHandler:
//     ^(FBSession *session, FBSessionState state, NSError *error) {
//         [self sessionStateChanged:session state:state error:error];
//     }];
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
            UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Login Failed", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"The password in incorrect", @"Login_Sign_Up", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [badLogin show];
        }
    };
    
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        [_delegate.credentialStore setAuthToken:[results objectForKey:@"id"] forUser:[results objectForKey:@"userId"]];
        [AppDelegate lbAdaptater].accessToken = [results objectForKey:@"id"];
        
        [userAuthenticator getCurrentUser];
        [self dismissTextFields];
        [self performSegueWithIdentifier:@"@Main" sender:self];
    };

    if ([self isValidEmail: _emailField.text]) {

        
        
        
        [User loginUserWithEmail:self.emailField.text andPassword:self.passwordField.text success:loadSuccessBlock failure:loadErrorBlock];

    } else {
        UIAlertView *badLogin = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Login Failed", @"Login_Sign_Up", nil) message:NSLocalizedStringFromTable(@"The email/password in incorrect", @"Login_Sign_Up", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
    BOOL performLogin = ![_delegate.credentialStore isLoggedIn];
    [MRProgressOverlayView showOverlayAddedTo:self.view title:NSLocalizedStringFromTable(@"Login in progress", @"Login_Sign_Up", nil) mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [fbAuthenticator loginFbAccountWithPermissions:@[] allowUI:YES
                                           success:^{
                                               [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
                                               if(performLogin)    [self performSegueWithIdentifier:@"@Main" sender:self];
                                           }
                                           failure:^(NSError *error) {
                                                NSLog(@"Error : %@", error.description);
                                               [MRProgressOverlayView dismissAllOverlaysForView:self.view animated:YES];
                                           }
     ];
}

- (void) showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
