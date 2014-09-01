//
//  CredentialStore.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 29/08/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CredentialStore.h"
#import <SSKeychain.h>

#define SERVICE_NAME @"Hairfie"
#define AUTH_TOKEN_KEY @"auth_token"
#define USER_ID_KEY @"user_id"


@implementation CredentialStore

- (BOOL)isLoggedIn {
    return [self authToken] != nil;
}

- (void)clearSavedCredentials {
    [self setAuthToken:nil];
    [self setAuthTokenAndUserId:nil forUser:nil];
}

- (NSString *)authToken {
    return [self secureValueForKey:AUTH_TOKEN_KEY];
}

- (NSString *)userId {
    return [self secureValueForKey:USER_ID_KEY];
}

- (void)setAuthToken:(NSString *)authToken {
    [self setSecureValue:authToken forKey:AUTH_TOKEN_KEY];
    NSLog(@"Store token");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"token-changed" object:self];
}

- (void)setAuthTokenAndUserId:(NSString *)authToken forUser:(NSString *)userId {
    [self setSecureValue:authToken forKey:AUTH_TOKEN_KEY];
    [self setSecureValue:userId forKey:USER_ID_KEY];
    NSLog(@"Store and Id token");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"token-user-changed" object:self];
}

- (void)setSecureValue:(NSString *)value forKey:(NSString *)key {
    if (value) {
        [SSKeychain setPassword:value
                     forService:SERVICE_NAME
                        account:key];
    } else {
        [SSKeychain deletePasswordForService:SERVICE_NAME account:key];
    }
}

- (NSString *)secureValueForKey:(NSString *)key {
    return [SSKeychain passwordForService:SERVICE_NAME account:key];
}

@end
