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
    
    NSLog(@"Jviens la %@", [AppDelegate lbAdaptater].accessToken);
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %zd", error.code);
        
    };
    void (^loadSuccessBlock)(LBModel *) = ^(LBModel *user){
        
        NSLog(@"User fetch LA : %@", user);
        email = user[@"email"];
        imageLink = user[@"picture"];
        name = [NSString stringWithFormat:@"%@ %@",user[@"firstName"], user[@"lastName"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
    };
    
    LBModelRepository *userRepository = [[AppDelegate lbAdaptater] repositoryWithModelName:@"users"];
    
    [userRepository findById:[delegate.credentialStore userId]
                      success:loadSuccessBlock
                      failure:loadErrorBlock];
}

@end
