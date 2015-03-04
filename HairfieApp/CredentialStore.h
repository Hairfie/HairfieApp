//
//  CredentialStore.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 29/08/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CredentialStore : NSObject

- (BOOL)isLoggedIn;
- (void)clearSavedCredentials;
- (NSString *)authToken;
- (NSString *)userId;
- (void)setAuthToken:(NSString *)authToken;
- (void)setAuthToken:(NSString *)authToken forUser:(NSString *)userId;
- (void)setTutorialSeen;
- (void)clearTutorialSeen;
- (BOOL)hasSeenTutorial;

@end
