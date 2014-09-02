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

@synthesize userId, userToken, email, firstName, lastName, picture;

-(NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

@end