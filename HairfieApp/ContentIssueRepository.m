//
//  ContentIssueRepository.m
//  HairfieApp
//
//  Created by Antoine Hérault on 17/03/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "ContentIssueRepository.h"

@implementation ContentIssueRepository

+(instancetype)repository
{
    return [self repositoryWithClassName:@"contentIssues"];
}

@end
