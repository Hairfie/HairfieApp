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
#import "Picture.h"
#import "Money.h"

@interface Hairfie : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) Picture *picture;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *hairdresserName;
@property (strong, nonatomic) Money *price;
@property (strong, nonatomic) NSNumber *numLikes;
@property (strong, nonatomic) NSString *numComments;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) User *author;
@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) NSArray *tags;

-(id)initWithDictionary:(NSDictionary *)data;

-(NSString *)pictureUrl;
-(NSString *)hairfieCellUrl;
-(NSString *)hairfieDetailUrl;
-(NSString *)displayPrice;
-(NSString *)displayNumLikes;
-(NSString *)displayNumComments;
-(NSAttributedString *)displayDescAndTags;

+(void)listLatest:(NSNumber *)limit
             skip:(NSNumber *)skip
          success:(void(^)(NSArray *hairfies))aSuccessHandler
          failure:(void(^)(NSError *error))aFailureHandler;

+(void)listLatestPerPage:(NSNumber *)page
                 success:(void(^)(NSArray *hairfies))aSuccessHandler
                 failure:(void(^)(NSError *error))aFailureHandler;

+(void)listLatestByBusiness:(NSString *)businessId
                      until:(NSDate *)until
                      limit:(NSNumber *)limit
                       skip:(NSNumber *)skip
                    success:(void(^)(NSArray *hairfies))aSuccessHandler
                    failure:(void(^)(NSError *error))aFailureHandler;

+(void)getHairfiesByAuthor:(NSString *)userId
                     until:(NSDate *)until
                     limit:(NSNumber *)limit
                      skip:(NSNumber *)skip
                   success:(void(^)(NSArray *hairfies))aSuccessHandler
                   failure:(void(^)(NSError *error))aFailureHandler;
                   
+(id)fromSetterValue:(id)aValue;

+(HairfieRepository *)repository;

@end
