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
@synthesize userId, userToken, email;

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
    void (^loadSuccessBlock)(LBModel *) = ^(LBModel *user){
        
        self.email = user[@"email"];
        self.imageLink = user[@"picture"];
        self.name = [NSString stringWithFormat:@"%@ %@",user[@"firstName"], user[@"lastName"]];
        
        
        NSLog(@"Current User : %@", user);
        NSLog(@"Login with : %@", self.name);

        
    };
    
    LBModelRepository *userRepository = [[AppDelegate lbAdaptater] repositoryWithModelName:@"users"];

    [userRepository findById:[delegate.credentialStore userId]
                      success:loadSuccessBlock
                      failure:loadErrorBlock];
}

@end
