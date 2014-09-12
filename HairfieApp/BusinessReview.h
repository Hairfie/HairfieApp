//
//  BusinessReview.h
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Business.h"
#import "User.h"

@interface BusinessReview : NSObject

@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) User *author;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSString *comment;

+(void)listLatestByBusiness:(NSString *)aBusinessId
                      limit:(NSNumber *)aLimit
                       skip:(NSNumber *)aNumber
                    success:(void(^)(NSArray *reviews))aSuccessHandler
                    failure:(void(^)(NSError *error))aFailureHandler;

@end
