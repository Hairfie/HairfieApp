//
//  BusinessClaimRepository.m
//  HairfieApp
//
//  Created by Leo Martin on 23/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessClaimRepository.h"

@implementation BusinessClaimRepository

+ (instancetype)repository {
    return [self repositoryWithClassName:@"businessClaims"];
}

@end
