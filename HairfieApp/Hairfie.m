//
//  Hairfie.m
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Hairfie.h"
#import "UserRepository.h"
#import "AppDelegate.h"

@implementation Hairfie

@synthesize description, hairfieId, salonId, price, picture, user = _user;


- (void) setUser:(NSDictionary *) userDic {
    
    UserRepository *userRepository = (UserRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
    _user = (User *)[userRepository modelWithDictionary:userDic];
}

-(NSString *)pictureUrl {
    return [picture objectForKey:@"publicUrl"];
}

@end
