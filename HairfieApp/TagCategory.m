
//
//  TagCategory.m
//  HairfieApp
//
//  Created by Antoine Hérault on 22/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TagCategory.h"
#import "AppDelegate.h"
#import "SetterUtils.h"

@implementation TagCategory

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return (TagCategory *)[[[self class] repository] modelWithDictionary:aDictionary];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithModelName:@"tagCategories"];
}

@end
