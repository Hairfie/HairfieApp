//
//  TagRepository.m
//  HairfieApp
//
//  Created by Leo Martin on 10/27/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TagRepository.h"

@implementation TagRepository

+(instancetype)repository
{
    return [self repositoryWithClassName:@"tags"];
}

@end
