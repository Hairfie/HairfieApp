//
//  HairdresserRepository.m
//  HairfieApp
//
//  Created by Antoine Hérault on 15/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairdresserRepository.h"

@implementation HairdresserRepository

+(instancetype)repository
{
    return [self repositoryWithClassName:@"hairdressers"];
}

@end
