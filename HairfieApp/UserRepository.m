//
//  UserRepository.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 01/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UserRepository.h"

@implementation UserRepository

+ (instancetype)repository {
    return [self repositoryWithClassName:@"users"];
}

@end
