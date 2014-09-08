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

- (void) getCurrentUser {
    
    UserRepository *userRepository = (UserRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
    __block User *user;
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
    };
    void (^loadSuccessBlock)(LBModel *) = ^(LBModel *model){
        user = (User*)model;
        
        delegate.currentUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
    };
    
    NSString *userId = [delegate.credentialStore userId];
    
    [userRepository findById:userId
                     success:loadSuccessBlock
                     failure:loadErrorBlock];
    
}

@end
