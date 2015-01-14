//
//  BusinessMemberClaimRepository.m
//  HairfieApp
//
//  Created by Antoine Hérault on 14/01/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "BusinessMemberClaimRepository.h"

@implementation BusinessMemberClaimRepository

+(instancetype)repository
{
    return [self repositoryWithClassName:@"businessMemberClaims"];
}

@end
