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

- (User *) getCurrentUser {
    
    UserRepository *userRepository = (UserRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
    __block User *user;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %d", error.code);
        dispatch_semaphore_signal(semaphore);
    };
    void (^loadSuccessBlock)(LBModel *) = ^(LBModel *model){
        user = (User *)model;
        NSLog(@"User : %@", user);
        dispatch_semaphore_signal(semaphore);
    };
    
    
    
    [userRepository findById:[delegate.credentialStore userId]
                     success:loadSuccessBlock
                     failure:loadErrorBlock];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
    
    return user;
}

@end
