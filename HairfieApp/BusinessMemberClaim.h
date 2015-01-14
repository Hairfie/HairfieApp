//
//  BusinessMemberClaim.h
//  HairfieApp
//
//  Created by Antoine Hérault on 14/01/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>

@interface BusinessMemberClaim : LBModel

@property (atomic, strong) NSString* businessId;

+(void)createWithBusiness:(NSString *)businessId
                  success:(void(^)())aSuccessHandler
                  failure:(void(^)(NSError *error))aFailureHandler;

@end
