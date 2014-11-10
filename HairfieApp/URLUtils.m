//
//  URLUtils.m
//  HairfieApp
//
//  Created by Antoine Hérault on 07/11/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "URLUtils.h"

@implementation URLUtils

+(NSURL *)URLFromSetterValue:(id)aValue
{
    if ([aValue isKindOfClass:[NSURL class]]) {
        return aValue;
    }

    if ([aValue isKindOfClass:[NSString class]]) {
        return [NSURL URLWithString:aValue];
    }

    if ([aValue isEqual:[NSNull null]]) {
        return aValue;
    }

    [NSException raise:@"Invalid URL value" format:@"value %@ is invalid", aValue];

    return nil;
}

@end
