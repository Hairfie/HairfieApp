//
//  Category.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 13/04/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "SearchCategory.h"
#import "AppDelegate.h"
#import "SetterUtils.h"
#import "SearchCategoryRepository.h"

@implementation SearchCategory

@synthesize description = _description;

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return (SearchCategory *)[[[self class] repository] modelWithDictionary:aDictionary];
}

-(void)setPicture:(id)aPicture
{
    _picture = [Picture fromSetterValue:aPicture];
}

//-(void)setTags:(id)someTags
//{
//    NSMutableArray *temp = [[NSMutableArray alloc] init];
//    if (![someTags isEqual:[NSNull null]]) {
//        for (id aTag in someTags) {
//            [temp addObject:[Tag fromSetterValue:aTag]];
//        }
//    }
//    _tags = [[NSArray alloc] initWithArray:temp];
//}

+(void)getCategoryWithSuccess:(void (^)(NSArray *))aSuccessHandler failure:(void (^)(NSError *))aFailureHandler {

    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/categories" verb:@"GET"] forMethod:@"categories.find"];
    
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        for (NSDictionary *result in results) {
            SearchCategory *cat = [[SearchCategory alloc] initWithDictionary:result];
            [temp addObject:cat];
        }
        
        NSArray *cats = [temp sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]]];
        
        aSuccessHandler([[NSArray alloc] initWithArray:cats]);
    };
    
    [[self repository] invokeStaticMethod:@"find" parameters:@{} success:loadSuccessBlock failure:aFailureHandler];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

+(SearchCategoryRepository *)repository {
    return (SearchCategoryRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[SearchCategoryRepository class]];
}

@end
