//
//  HairdresserSearchQuery.m
//  HairfieApp
//
//  Created by Antoine Hérault on 01/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairdresserSearchQuery.h"
#import "Business.h"

@implementation HairdresserSearchQuery

-(void)resultsWithLimit:(NSNumber *)aLimit
                   skip:(NSNumber *)aSkip
                success:(void (^)(NSArray *))aSuccessHandler
                failure:(void (^)(NSError *))aFailureHandler
{
    if ([self.location isEqual:[NSNull null]]) {
        
    }
    
    [Business listNearby:self.location
                   query:self.query
                   limit:aLimit
                 success:aSuccessHandler
                 failure:aFailureHandler];
}

@end
