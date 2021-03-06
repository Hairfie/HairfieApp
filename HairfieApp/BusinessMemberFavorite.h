//
//  BusinessMemberFavorite.h
//  HairfieApp
//
//  Created by Antoine Hérault on 19/12/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>
#import "BusinessMember.h"

@interface BusinessMemberFavorite : LBModel

@property (strong, nonatomic) BusinessMember* businessMember;
@property (strong, nonatomic) NSDate* createdAt;

+(void)getBusinessMemberFavoritesByUser:(NSString *)aUserId
                            withSuccess:(void (^)(NSArray *))aSuccessHandler
                                failure:(void (^)(NSError *))aFailureHandler;

@end
