//
//  BusinessRepository.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 10/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessRepository.h"

@implementation BusinessRepository

+ (instancetype)repository {
    return [self repositoryWithClassName:@"businesses"];
}

@end
