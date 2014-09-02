//
//  UserAuthenticator.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 01/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserAuthenticator : NSObject

- (User *) getCurrentUser;

@end
