//
//  SuggestHairdresserReport.m
//  HairfieApp
//
//  Created by Leo Martin on 10/29/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SuggestHairdresserReport.h"
#import "AppDelegate.h"

@implementation SuggestHairdresserReport

-(id)initWithBusiness:(Business *)aBusiness
{
    self = [super init];
    if (self) {
        self.business = aBusiness;
    }
    return self;
}

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:self.business.id forKey:@"businessId"];
    
    if (nil != self.lastName) {
        [parameters setObject:self.lastName forKey:@"lastName"];
    }
    if (nil != self.firstName) {
        [parameters setObject:self.firstName forKey:@"firstName"];
    }
    
    
    NSLog(@"PARAMS %@", parameters);
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
    return [[AppDelegate lbAdaptater] repositoryWithModelName:@"hairdresserSuggestions"];
}



@end
