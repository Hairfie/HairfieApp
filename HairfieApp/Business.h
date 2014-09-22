//
//  Business.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>
#import "Address.h"
#import "GeoPoint.h"


@interface Business : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) GeoPoint *gps;
@property (strong, nonatomic) NSArray *phoneNumbers;
@property (strong, nonatomic) NSDictionary *timetable; // TODO: add a Timetable model?
@property (strong, nonatomic) Address *address;
@property (strong, nonatomic) NSArray *pictures;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSNumber *distance; // TODO: calculate it from frontend
@property (strong, nonatomic) NSArray *prices;
@property (strong, nonatomic) NSNumber *numHairfies;
@property (strong, nonatomic) NSNumber *numReviews;
@property (strong, nonatomic) NSNumber *rating;
@property (nonatomic) BOOL crossSell;

-(NSString *)displayNameAndAddress;

-(NSString *)displayNumHairfies;

+(void)listNearby:(GeoPoint *)aGeoPoint
            query:(NSString *)aQuery
            limit:(NSNumber *)aLimit
          success:(void(^)(NSArray *business))aSuccessHandler
          failure:(void(^)(NSError *error))aFailureHandler;

+(void)listSimilarTo:(NSString *)aBusinessId
               limit:(NSNumber *)aLimit
             success:(void(^)(NSArray *businesses))aSuccessHandler
             failure:(void(^)(NSError *error))aFailureHandler;

-(id)initWithDictionary:(NSDictionary *)data;

-(NSNumber *)ratingBetween:(NSNumber *)aMin
                       and:(NSNumber *)aMax;

@end
