//
//  BusinessMemberRepository.m
//  HairfieApp
//
//  Created by Antoine Hérault on 15/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessMemberRepository.h"

@implementation BusinessMemberRepository

+(instancetype)repository
{
    return [self repositoryWithClassName:@"businessMembers"];
}

@end
