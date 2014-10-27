//
//  SetterUtils.m
//  HairfieApp
//
//  Created by Antoine Hérault on 23/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SetterUtils.h"

@implementation SetterUtils

+(id)getInstanceOf:(Class)aClass
   fromSetterValue:(id)aValue
{
    if ([aValue isEqual:[NSNull null]]) {
        return nil;
    }

    if ([aValue isKindOfClass:aClass]) {
        return aValue;
    }

    if ([aValue isKindOfClass:[NSDictionary class]]) {
        return [[aClass alloc] initWithDictionary:aValue];
    }

    [NSException raise:@"Invalid setter value" format:@"Failed to create %@ instance from value %@", aClass, aValue];

    return nil;
}

@end
