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

@implementation User
{
    AppDelegate *delegate;
}
@synthesize userId, userToken;

- (id)init {
    self = [super init];
    if (self) {
     delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void) getCurrentUser {
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %ld", error.code);
        
    };
    void (^loadSuccessBlock)(LBModel *) = ^(LBModel *model){
        NSLog(@"model %@", model);
        //NSDictionary *userData = [results objectForKey:@"user"];
        
//        _delegate.currentUser.name = [NSString stringWithFormat:@"%@ %@",[userData objectForKey:@"firstName"], [userData objectForKey:@"lastName"] ];
//        _delegate.currentUser.imageLink = [userData objectForKey:@"picture"];
        
    };
    
    LBModelRepository *userRepository = [[AppDelegate lbAdaptater] repositoryWithModelName:@"users"];

    [userRepository findById:[delegate.credentialStore userId]
                      success:loadSuccessBlock
                      failure:loadErrorBlock];
}

@end
