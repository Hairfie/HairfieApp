//
//  SearchCategoryRepository.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 13/04/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "SearchCategoryRepository.h"

@implementation SearchCategoryRepository

+(instancetype)repository
{
    return [self repositoryWithClassName:@"categories"];
}

@end
