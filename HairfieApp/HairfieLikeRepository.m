
//
//  HairfieLikeRepository.m
//  HairfieApp
//
//  Created by Antoine Hérault on 18/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieLikeRepository.h"

@implementation HairfieLikeRepository

+(instancetype)repository
{
    return [self repositoryWithClassName:@"hairfieLikes"];
}

@end
