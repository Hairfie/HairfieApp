
//
//  HairfieRepository.m
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieRepository.h"

@implementation HairfieRepository

+ (instancetype)repository {
    return [self repositoryWithClassName:@"hairfies"];
}

@end
