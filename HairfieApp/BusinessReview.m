//
//  BusinessReview.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessReview.h"
#import "BusinessReviewRepository.h"
#import "AppDelegate.h"

@implementation BusinessReview


-(id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    
    
    
    
    LBModelRepository *repository = [[AppDelegate lbAdaptater] repositoryWithClass:[BusinessReviewRepository class]];

    self = (BusinessReview*)[repository modelWithDictionary:data];
    return self;
}


-(void)save
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
        NSLog(@"results %@", results);
    };
    
    
    NSString *repoName = @"businessReviews";
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessreviews" verb:@"POST"] forMethod:@"businessreviews"];
    
    LBModelRepository *reviewData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];

    [reviewData invokeStaticMethod:@"" parameters:@{@"comment":_comment, @"rating":_rating, @"businessId": _business.id} success:loadSuccessBlock failure:loadErrorBlock];

}

+(void)listLatestByBusiness:(NSString *)aBusinessId
                      limit:(NSNumber *)aLimit
                       skip:(NSNumber *)aNumber
                    success:(void (^)(NSArray *))aSuccessHandler
                    failure:(void (^)(NSError *))aFailureHandler
{
    aSuccessHandler(@[]);
}


+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[BusinessReviewRepository class]];
}



@end
