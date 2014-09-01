//
//  User.m
//  HairfieApp
//
//  Created by Leo Martin on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "User.h"
#import "CredentialStore.h"
#import "AppDelegate.h"
#import "MenuViewController.h"

@implementation User
{
    AppDelegate *delegate;
}
@synthesize userId, userToken, email, name, imageLink;

- (id)init {
    self = [super init];
    if (self) {
     delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void) getCurrentUser {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %d", error.code);
        dispatch_semaphore_signal(semaphore);
    };
    void (^loadSuccessBlock)(LBModel *) = ^(LBModel *user){
        
        email = user[@"email"];
        imageLink = user[@"picture"];
        name = [NSString stringWithFormat:@"%@ %@",user[@"firstName"], user[@"lastName"]];
        dispatch_semaphore_signal(semaphore);
    };
    
    
   
    LBModelRepository *userRepository = [[AppDelegate lbAdaptater] repositoryWithModelName:@"users"];

    [userRepository findById:[delegate.credentialStore userId]
                      success:loadSuccessBlock
                      failure:loadErrorBlock];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
}

@end
