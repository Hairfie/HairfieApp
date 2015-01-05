//
//  HairfieShare.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 24/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieShare.h"
#import "AppDelegate.h"


@implementation HairfieShare

+(void)shareHairfie:(NSString *)hairfieId
            success:(void(^)())aSuccessHandler
            failure:(void(^)(NSError *error))aFailureHandler {
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies/:hairfieId/share"
                                                                                 verb:@"POST"]
                                        forMethod:@"hairfies.share"];
    
    [[[self class] repository] invokeStaticMethod:@"share"
                               parameters:@{@"hairfieId": hairfieId, @"facebook": @"true"}
                                  success:^(id value) {
                                      NSLog(@"Sharing Result : %@", value);
                                      aSuccessHandler();
                                  }
                                  failure:aFailureHandler];
}

+(void)shareHairfiePro:(NSString *)hairfieId
            success:(void(^)())aSuccessHandler
            failure:(void(^)(NSError *error))aFailureHandler {

    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies/:hairfieId/share"
                                                                                 verb:@"POST"]
                                        forMethod:@"hairfies.share"];
    
    [[[self class] repository] invokeStaticMethod:@"share"
                                       parameters:@{@"hairfieId": hairfieId, @"facebookPage": @"true"}
                                          success:^(id value) {
                                              NSLog(@"Sharing Result : %@", value);
                                              aSuccessHandler();
                                          }
                                          failure:aFailureHandler];

}
+(HairfieRepository *)repository
{
    return (HairfieRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
}

@end
