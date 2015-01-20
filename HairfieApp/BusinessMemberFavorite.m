//
//  BusinessMemberFavorite.m
//  HairfieApp
//
//  Created by Antoine Hérault on 19/12/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessMemberFavorite.h"
#import "BusinessMemberFavoriteRepository.h"
#import "AppDelegate.h"
#import "BusinessMember.h"

@implementation BusinessMemberFavorite

-(void)setBusinessMember:(id)aBusinessMember
{
    _businessMember = [BusinessMember fromSetterValue:aBusinessMember];
}

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return (BusinessMemberFavorite *)[[[self class] repository] modelWithDictionary:aDictionary];
}

+(void)getBusinessMemberFavoritesByUser:(NSString *)aUserId
                            withSuccess:(void (^)(NSArray *))aSuccessHandler
                                failure:(void (^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:id/favorite-business-members"
                                                                                 verb:@"GET"]
                                        forMethod:@"businessMemberFavorites.findByUser"];
    
    [[[self class] repository] invokeStaticMethod:@"findByUser"
                                       parameters:@{@"id":aUserId}
                                          success:^(NSArray *results) {
                                              NSMutableArray *temp = [[NSMutableArray alloc] init];
                                              for (NSDictionary *result in results) {
                                                  [temp addObject:[[BusinessMemberFavorite alloc] initWithDictionary:result]];
                                              }
                                              aSuccessHandler([[NSArray alloc] initWithArray:temp]);
                                          }
                                          failure:aFailureHandler];
}

+(BusinessMemberFavoriteRepository *)repository
{
    return (BusinessMemberFavoriteRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[BusinessMemberFavoriteRepository class]];
}

@end
