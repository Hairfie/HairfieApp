
//
//  TagCategory.m
//  HairfieApp
//
//  Created by Antoine Hérault on 22/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "TagCategory.h"
#import "AppDelegate.h"

@implementation TagCategory

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return (TagCategory *)[[[self class] repository] modelWithDictionary:aDictionary];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithModelName:@"tagCategories"];
}

@end
