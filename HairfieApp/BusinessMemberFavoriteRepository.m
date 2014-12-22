//
//  BusinessMemberFavoriteRepository.m
//  HairfieApp
//
//  Created by Antoine Hérault on 19/12/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessMemberFavoriteRepository.h"

@implementation BusinessMemberFavoriteRepository

+(instancetype)repository
{
    return [self repositoryWithClassName:@"businessMemberFavorites"];
}

@end
