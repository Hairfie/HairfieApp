//
//  DateUtils.m
//  HairfieApp
//
//  Created by Antoine Hérault on 23/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils


+(id)dateFromSetterValue:(id)aValue
{
    if ([aValue isKindOfClass:[NSDate class]]) {
        return aValue;
    }
    
    if ([aValue isKindOfClass:[NSString class]]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:API_DATE_FORMAT];
        return [dateFormatter dateFromString:aValue];
    }
    
    if ([aValue isEqual:[NSNull null]]) {
        return aValue;
    }
    
    [NSException raise:@"Invalid date value" format:@"value %@ is invalid", aValue];
    
    return nil;
}

@end
