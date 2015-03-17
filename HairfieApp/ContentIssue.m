//
//  ContentIssue.m
//  HairfieApp
//
//  Created by Antoine Hérault on 17/03/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "ContentIssue.h"
#import "ContentIssueRepository.h"
#import "AppDelegate.h"

@implementation ContentIssue

+(void)createWithTitle:(NSString *)theTitle
               andBody:(NSString *)theBody
               success:(void (^)())aSuccessHandler
               failure:(void (^)(NSError *))aFailureHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:theTitle forKey:@"title"];
    if (nil != theBody) {
        [parameters setValue:theBody forKey:@"body"];
    }
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/contentIssues"
                                                                                 verb:@"POST"]
                                        forMethod:@"contentIssues.create"];
    
    [[[self class] repository] invokeStaticMethod:@"create"
                                       parameters:parameters
                                          success:aSuccessHandler
                                          failure:aFailureHandler];
}


+(ContentIssueRepository *)repository
{
    return (ContentIssueRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[ContentIssueRepository class]];
}

@end
