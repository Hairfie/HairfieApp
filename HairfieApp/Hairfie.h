//
//  Hairfie.h
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h> 
#import "User.h"
#import "Business.h"

@interface Hairfie : LBModel

@property (nonatomic) NSDictionary *picture;
@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *businessId;
@property (nonatomic) NSDictionary *price;
@property (nonatomic) NSString *hairfieId;
@property (nonatomic) NSString *numLikes;
@property (nonatomic) NSString *numComments;
@property (nonatomic) User *user;
@property (nonatomic) Business *business;


-(NSString *)pictureUrl;
-(NSString *)hairfieCellUrl;
-(NSString *)hairfieDetailUrl;
-(NSString *)displayPrice;


+(void)listLatestByUser:(NSString *)userId
                  limit:(NSNumber *)limit
                   skip:(NSNumber *)skip
                success:(void(^)(NSArray *hairfies))aSuccessHandler
                failure:(void(^)(NSError *error))aFailureHandler;

@end
