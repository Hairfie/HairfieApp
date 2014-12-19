
//
//  TagCategoryRepository.m
//  HairfieApp
//
//  Created by Leo Martin on 10/27/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TagCategoryRepository.h"

@implementation TagCategoryRepository

+(instancetype)repository
{
    return [self repositoryWithClassName:@"tagCategories"];
}

@end
