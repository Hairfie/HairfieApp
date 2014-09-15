//
//  BusinessReviewRepository.m
//  HairfieApp
//
//  Created by Leo Martin on 15/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessReviewRepository.h"

@implementation BusinessReviewRepository

+ (instancetype)repository {
    return [self repositoryWithClassName:@"businessreviews"];
}

@end
