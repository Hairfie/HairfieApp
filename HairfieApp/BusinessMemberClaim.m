//
//  BusinessMemberClaim.m
//  HairfieApp
//
//  Created by Antoine Hérault on 14/01/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "BusinessMemberClaim.h"
#import "BusinessMemberClaimRepository.h"
#import "AppDelegate.h"

@implementation BusinessMemberClaim

+(void)createWithBusiness:(NSString *)businessId
                  success:(void (^)())aSuccessHandler
                  failure:(void (^)(NSError *))aFailureHandler
{
    BusinessMemberClaim *bmc = [[BusinessMemberClaim alloc] init];
    bmc.businessId = businessId;
    [bmc saveWithSuccess:aSuccessHandler failure:aFailureHandler];
}

-(NSDictionary *)toDictionary
{
    return @{@"businessId": self.businessId};
}

-(void)saveWithSuccess:(void (^)())aSuccessHandler
               failure:(void (^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessMemberClaims"
                                                                                 verb:@"POST"]
                                        forMethod:@"businessMemberClaims.create"];
    
    [[[self class] repository] invokeStaticMethod:@"create"
                                       parameters:[self toDictionary]
                                          success:aSuccessHandler
                                          failure:aFailureHandler];
}

+(BusinessMemberClaimRepository *)repository
{
    return (BusinessMemberClaimRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[BusinessMemberClaimRepository class]];
}

@end