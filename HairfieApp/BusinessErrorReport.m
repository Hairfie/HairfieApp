//
//  BusinessErrorReport.m
//  HairfieApp
//
//  Created by Antoine Hérault on 29/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessErrorReport.h"
#import "AppDelegate.h"

@implementation BusinessErrorReport

-(id)initWithBusiness:(Business *)aBusiness
                 body:(NSString *)aBody
{
    self = [super init];
    if (self) {
        self.business = aBusiness;
        self.body = aBody;
    }
    return self;
}

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:self.business.id forKey:@"businessId"];
    
    if (nil != self.body) {
        [parameters setObject:self.body forKey:@"body"];
    }
    
    [[[self class] repository] invokeStaticMethod:@""
                                       parameters:parameters
                                          success:^(NSDictionary *result) {
                                              // TODO: update model with result's values
                                              aSuccessHandler();
                                          }
                                          failure:aFailureHandler];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithModelName:@"businessErrorReports"];
}

@end
