//
//  Hairfie.m
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Hairfie.h"
#import "UserRepository.h"
#import "BusinessRepository.h"
#import "AppDelegate.h"

@implementation Hairfie

@synthesize description, hairfieId, businessId, price, picture, user = _user, business = _business;


- (void) setUser:(NSDictionary *) userDic {
    
    UserRepository *userRepository = (UserRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
    _user = (User *)[userRepository modelWithDictionary:userDic];
}

- (void) setBusiness:(NSDictionary *) businessDic {
    if([businessDic isKindOfClass:[NSNull class]]) {
        
    } else {
        BusinessRepository *businessRepository = (BusinessRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[BusinessRepository class]];
        _business = (Business *)[businessRepository modelWithDictionary:businessDic];
    }
   }

-(NSString *)pictureUrl {
    return [picture objectForKey:@"publicUrl"];
}

-(NSString *)displayPrice {
    if([price isEqual:[NSNull null]]) return @"";
    
    if([[price objectForKey:@"currency"] isEqual:@"EUR"]) return [NSString stringWithFormat:@"%@ €", [price objectForKey:@"amount"]];

    return @"";
}

@end
