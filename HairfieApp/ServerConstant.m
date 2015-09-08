//
//  ServerConstant.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 15/04/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "ServerConstant.h"
#import "AppDelegate.h"
#import "SearchCategory.h"
#import "Tag.h"

@implementation ServerConstant {
    AppDelegate *delegate;
}

- (id)init {
    self = [super init];
    if (self) {
        delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

-(void)getCategories {
    __block NSArray *categories;
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error  %@", [error userInfo]);
        [self getCategories];
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results){
        categories = [results sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]]];
        
        delegate.categories = categories;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getCategories" object:self];
    };
    
    [SearchCategory getCategoriesWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}

-(void)getTags {
    __block NSArray *tags;

    void (^successHandler)(NSArray *) = ^(NSArray *results) {
        tags = [NSMutableArray arrayWithArray:results];
        delegate.tags = tags;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getTags" object:self];
    };
    
    void (^failureHandler)(NSError *) = ^(NSError *error) {
        NSLog(@"Failed to get tags with error %@", error.description);
        [self getTags];
    };
    
    [Tag getTagsGroupedByCategoryWithSuccess:successHandler failure:failureHandler];
}

@end