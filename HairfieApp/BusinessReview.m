//
//  BusinessReview.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessReview.h"

@implementation BusinessReview

+(void)listLatestByBusiness:(NSString *)aBusinessId
                      limit:(NSNumber *)aLimit
                       skip:(NSNumber *)aNumber
                    success:(void (^)(NSArray *))aSuccessHandler
                    failure:(void (^)(NSError *))aFailureHandler
{
    aSuccessHandler(@[]);
}

@end
