//
//  ServiceRepository.m
//  HairfieApp
//
//  Created by Leo Martin on 2/18/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "ServiceRepository.h"

@implementation ServiceRepository

+ (instancetype)repository {
    return [self repositoryWithClassName:@"businessServices"];
}

@end