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
#import "HairfieRepository.h"

@interface Hairfie : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSDictionary *picture;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSDictionary *price;
@property (strong, nonatomic) NSString *numLikes;
@property (strong, nonatomic) NSString *numComments;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) User *author;
@property (strong, nonatomic) Business *business;

-(id)initWithDictionary:(NSDictionary *)data;

-(NSString *)pictureUrl;
-(NSString *)hairfieCellUrl;
-(NSString *)hairfieDetailUrl;
-(NSString *)displayPrice;
-(NSString *)displayNumLikes;
-(NSString *)displayNumComments;


+(void)listLatest:(NSNumber *)limit
             skip:(NSNumber *)skip
          success:(void(^)(NSArray *hairfies))aSuccessHandler
          failure:(void(^)(NSError *error))aFailureHandler;

+(void)listLatestPerPage:(NSNumber *)page
                 success:(void(^)(NSArray *hairfies))aSuccessHandler
                 failure:(void(^)(NSError *error))aFailureHandler;

+(void)listLatestByBusiness:(NSString *)businessId
                      limit:(NSNumber *)limit
                       skip:(NSNumber *)skip
                    success:(void(^)(NSArray *hairfies))aSuccessHandler
                    failure:(void(^)(NSError *error))aFailureHandler;

+(HairfieRepository *)repository;

@end
