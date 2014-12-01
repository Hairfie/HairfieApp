//
//  FBAuthenticator.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 24/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FBAuthenticator.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "UserAuthenticator.h"
#import "MRProgress.h"

@implementation FBAuthenticator {
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


-(void)linkFbAccountWithPermissions:(NSArray *) permissionsNeeded
                            success:(void(^)()) aSuccessHandler
                            failure:(void(^)(NSError *error)) aFailureHandler {
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error on load %@", error.description);
        aFailureHandler(error);
    };
    
    void (^loadSuccessBlock)(NSString *) = ^(NSString *fbAuthToken) {
        [self linkWithFbToken:fbAuthToken success:aSuccessHandler failure:aFailureHandler];
    };

    NSArray *basicPermissions = @[@"public_profile", @"email"];
    
    NSMutableArray *uniqueElementsInNeeded = [permissionsNeeded mutableCopy];
    [uniqueElementsInNeeded removeObjectsInArray:basicPermissions];
    
    NSMutableArray *uniqueElementsInBasic = [basicPermissions mutableCopy];
    [uniqueElementsInBasic removeObjectsInArray:permissionsNeeded];
    
    NSArray *permissions = [uniqueElementsInNeeded arrayByAddingObjectsFromArray:uniqueElementsInBasic];
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [self sessionStateChanged:FBSession.activeSession state:FBSession.activeSession.state error:nil success:loadSuccessBlock failure:loadErrorBlock];
    } else {
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error success:loadSuccessBlock failure:loadErrorBlock];
         }];
    }
}

-(void)loginFbAccountWithPermissions:(NSArray *) permissionsNeeded
                             allowUI:(BOOL)allowUI
                            success:(void(^)()) aSuccessHandler
                            failure:(void(^)(NSError *error)) aFailureHandler {
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error on load %@", error.description);
        aFailureHandler(error);
    };
    
    void (^loadSuccessBlock)(NSString *) = ^(NSString *fbAuthToken) {
        [self loginWithFbToken:fbAuthToken success:aSuccessHandler failure:aFailureHandler];
    };
    
    NSArray *basicPermissions = @[@"public_profile", @"email"];
    
    NSMutableArray *uniqueElementsInNeeded = [permissionsNeeded mutableCopy];
    [uniqueElementsInNeeded removeObjectsInArray:basicPermissions];
    
    NSMutableArray *uniqueElementsInBasic = [basicPermissions mutableCopy];
    [uniqueElementsInBasic removeObjectsInArray:permissionsNeeded];
    
    NSArray *permissions = [uniqueElementsInNeeded arrayByAddingObjectsFromArray:uniqueElementsInBasic];
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [self sessionStateChanged:FBSession.activeSession state:FBSession.activeSession.state error:nil success:loadSuccessBlock failure:loadErrorBlock];
    } else {
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:allowUI
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error success:loadSuccessBlock failure:loadErrorBlock];
         }];
    }
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState)state
                      error:(NSError *)error
                    success:(void(^)(NSString *fbAuthToken))aSuccessHandler
                    failure:(void(^)(NSError *error))aFailureHandler {
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        
        FBAccessTokenData *accessTokenData = [session accessTokenData];
        NSString *fbAuthToken = [accessTokenData accessToken];
        delegate.fbSession = session;
        
        aSuccessHandler(fbAuthToken);
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        NSLog(@"Session closed");
        aFailureHandler(nil);
    }
    
    if (error){
        NSLog(@"Error : %@", error.description);
        [FBSession.activeSession closeAndClearTokenInformation];
        aFailureHandler(error);
    }
}

-(void)linkWithFbToken:(NSString*)fbAuthToken
               success:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error on load %@", error.description);
        [FBSession.activeSession closeAndClearTokenInformation];
        aFailureHandler(error);
    };
    
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        aSuccessHandler();
    };
    
    NSString *repoName = @"link/facebook";
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"token" verb:@"POST"] forMethod:@"token"];
    
    LBModelRepository *loginData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
    
    [loginData invokeStaticMethod:@"token" parameters:@{@"access_token":fbAuthToken} success:loadSuccessBlock failure:loadErrorBlock];
}

-(void)loginWithFbToken:(NSString*)fbAuthToken
               success:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler {
    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error on load %@", error.description);
        [FBSession.activeSession closeAndClearTokenInformation];
        aFailureHandler(error);
    };
    
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results) {
        [delegate.credentialStore setAuthTokenAndUserId:[results objectForKey:@"id"] forUser:[results objectForKey:@"userId"]];
        [AppDelegate lbAdaptater].accessToken = [results objectForKey:@"id"];
        [userAuthenticator getCurrentUser];
        aSuccessHandler();
    };
    
    NSString *repoName = @"auth/facebook";
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"token" verb:@"POST"] forMethod:@"token"];
    
    LBModelRepository *loginData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
    
    [loginData invokeStaticMethod:@"token" parameters:@{@"access_token":fbAuthToken} success:loadSuccessBlock failure:loadErrorBlock];
}

@end
