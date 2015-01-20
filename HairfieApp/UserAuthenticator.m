//
//  UserAuthenticator.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 01/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UserAuthenticator.h"
#import "User.h"
#import "UserRepository.h"
#import "CredentialStore.h"
#import "AppDelegate.h"
#import "MenuViewController.h"

@implementation UserAuthenticator {
    AppDelegate *delegate;
}

- (id)init {
    self = [super init];
    if (self) {
        delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)getCurrentUser
{
    __block User *user;
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error  %@", [error userInfo]);
        NSString *httpString = [[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"];
        if(httpString) {
            NSDictionary *httpDic = [NSJSONSerialization
                                     JSONObjectWithData:[httpString dataUsingEncoding:NSUTF8StringEncoding]
                                                options:NSJSONReadingMutableContainers
                                                error: &error];
            int statusCode = (int)[[[httpDic objectForKey:@"error"] objectForKey:@"statusCode"] integerValue];

            if(statusCode == 404 || statusCode == 401) {
                [delegate.credentialStore clearSavedCredentials];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"badCredentials" object:self];
            }
        }
        NSLog(@"Error on load %@", error.description);
    };
    void (^loadSuccessBlock)(User *) = ^(User *result){
        user = result;
        
        delegate.currentUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userLanguage" object:nil];
        [ARAnalytics identifyUserWithID:user.id andEmailAddress:user.email];
    };
    
    NSString *userId = [delegate.credentialStore userId];
    
    [User getById:userId success:loadSuccessBlock failure:loadErrorBlock];
}

-(void) skipLogin {
    delegate.currentUser = nil;
    [delegate.credentialStore clearSavedCredentials];
    [ARAnalytics event:@"AR - Skip"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"skipLogin" object:self];
}

@end
