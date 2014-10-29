
//
//  TagCategory.m
//  HairfieApp
//
//  Created by Antoine Hérault on 22/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TagCategory.h"
#import "TagCategoryRepository.h"
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

+(TagCategoryRepository *)repository
{
    return (TagCategoryRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[TagCategoryRepository class]];
}

@end
