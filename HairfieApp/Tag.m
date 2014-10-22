//
//  Tag.m
//  HairfieApp
//
//  Created by Antoine Hérault on 22/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Tag.h"
#import "AppDelegate.h"

@implementation Tag

-(void)setCategory:(id)aCategory
{
    if ([aCategory isKindOfClass:[TagCategory class]]) {
        _category = aCategory;
        return;
    }
    
    if ([aCategory isKindOfClass:[NSDictionary class]]) {
        _category = [[TagCategory alloc] initWithDictionary:aCategory];
        return;
    }
    
    if ([aCategory isEqual:[NSNull null]]) {
        _category = nil;
        return;
    }
    
    [NSException raise:@"Invalid category value" format:@"value %@ is invalid", aCategory];
}

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return (Tag *)[[[self class] repository] modelWithDictionary:aDictionary];
}

+(void)getTagsGroupedByCategoryWithSuccess:(void (^)(NSArray *))aSuccessHandler
                                   failure:(void (^)(NSError *))aFailureHandler
{
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];

        for (NSDictionary *result in results) {
            Tag *tag = [[Tag alloc] initWithDictionary:result];

            // a tag with no category can't be grouped
            if (nil == tag.category.id) {
                continue;
            }

            // add tag to its category's group
            NSArray *group = [temp objectForKey:tag.category.id];
            if (nil == group) {
                group = @[tag.category, [[NSMutableArray alloc] init]];
                [temp setObject:group forKey:tag.category.id];
            }
            [group[1] addObject:tag];
        }

        aSuccessHandler([temp allValues]);
    };
    
    [[self repository] invokeStaticMethod:@"/" parameters:@{} success:loadSuccessBlock failure:aFailureHandler];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithModelName:@"tags"];
}

@end
