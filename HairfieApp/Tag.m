//
//  Tag.m
//  HairfieApp
//
//  Created by Antoine Hérault on 22/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Tag.h"
#import "AppDelegate.h"
#import "SetterUtils.h"
#import "TagRepository.h"

@implementation Tag

@synthesize id;
-(void)setCategory:(id)aCategory
{
    _category = [TagCategory fromSetterValue:aCategory];
}

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    
    
    return (Tag *)[[[self class] repository] modelWithDictionary:aDictionary];
}

-(NSString *)toApiValue
{
    return self.id;
}

+(void)getTagsGroupedByCategoryWithSuccess:(void (^)(NSArray *))aSuccessHandler
                                   failure:(void (^)(NSError *))aFailureHandler
{
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/tags" verb:@"GET"]
                                        forMethod:@"tags.find"];
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results) {
        NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];

        for (NSDictionary *result in results) {
            
            Tag *tag = [[Tag alloc] initWithDictionary:result];
            
            // a tag with no category can't be grouped
            if (nil == tag.category || nil == tag.category.id) {
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
    

    
    [[self repository] invokeStaticMethod:@"find" parameters:@{} success:loadSuccessBlock failure:aFailureHandler];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

+(TagRepository *)repository
{
    return (TagRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[TagRepository class]];
}

@end
