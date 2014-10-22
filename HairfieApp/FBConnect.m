//
//  FBConnect.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 22/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FBConnect.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "UserAuthenticator.h"

@implementation FBConnect {
    AppDelegate *delegate;
    UserAuthenticator *userAuthenticator;
}

- (id)init {
    self = [super init];
    if (self) {
        delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        userAuthenticator = [[UserAuthenticator alloc] init];
    }
    return self;
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
    };
    
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        BOOL performLogin = ![delegate.credentialStore isLoggedIn];
        [AppDelegate lbAdaptater].accessToken = [results objectForKey:@"id"];
        [delegate.credentialStore setAuthTokenAndUserId:[results objectForKey:@"id"] forUser:[results objectForKey:@"userId"]];
        [userAuthenticator getCurrentUser];
        NSLog(@"FB Connected");
    };
    
    NSString *repoName = @"auth/facebook/token";
    
    [[fbLbAdaptater contract] addItem:[SLRESTContractItem itemWithPattern:@"" verb:@"POST"] forMethod:@"facebook.login"];
    
    LBModelRepository *loginData = [fbLbAdaptater repositoryWithModelName:repoName];
    
    [loginData invokeStaticMethod:@"" parameters:@{@"access_token":fbAuthToken} success:loadSuccessBlock failure:loadErrorBlock];
}

- (void) showMessage:(NSString *)alertText withTitle:(NSString *)alertTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

@end
