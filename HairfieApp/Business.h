//
//  Business.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>
#import "User.h"
#import "Address.h"
#import "GeoPoint.h"
#import "Timetable.h"
#import "Picture.h"
#import "FacebookPage.h"


@interface Business : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) User *owner;
@property (strong, nonatomic) NSString *kind;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) GeoPoint *gps;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) Timetable *timetable;
@property (strong, nonatomic) Address *address;
@property (strong, nonatomic) NSMutableArray *pictures;
@property (strong, nonatomic) Picture *thumbnail;
@property (strong, nonatomic) NSArray *services;
@property (strong, nonatomic) NSNumber *numHairfies;
@property (strong, nonatomic) NSNumber *numReviews;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSMutableArray *activeHairdressers;
@property (strong, nonatomic) FacebookPage *facebookPage;

@property (nonatomic) BOOL crossSell;

+(NSString *)EVENT_CHANGED;

-(void)reviewSaved:(NSNotification *)notification;

-(NSString *)displayNameAndAddress;

-(NSString *)displayNumHairfies;

-(NSNumber *)distanceTo:(GeoPoint *)aGeoPoint;

-(NSString *)displayBusinessNameForQuery;

-(id)initWithDictionary:(NSDictionary *)data;

-(NSNumber *)ratingBetween:(NSNumber *)aMin
                       and:(NSNumber *)aMax;

-(BOOL)isFacebookPageShareEnabled;

-(NSURL *)thumbnailUrlWithWidth:(NSNumber *)aWidth
                         height:(NSNumber *)anHeight;

+(void)listNearby:(GeoPoint *)aGeoPoint
            query:(NSString *)aQuery
      clientTypes:(NSArray *)clientTypes
            limit:(NSNumber *)aLimit
          success:(void(^)(NSArray *business))aSuccessHandler
          failure:(void(^)(NSError *error))aFailureHandler;

+(void)listSimilarTo:(NSString *)aBusinessId
               limit:(NSNumber *)aLimit
             success:(void(^)(NSArray *businesses))aSuccessHandler
             failure:(void(^)(NSError *error))aFailureHandler;

+(void)getById:(NSString *)anId
   withSuccess:(void(^)(Business *business))aSuccessHandler
       failure:(void(^)(NSError *error))aFailureHandler;

-(void)updateWithSuccess:(void(^)(NSArray *results))aSuccessHandler
                 failure:(void(^)(NSError *error))aFailureHandler;

-(void)claimWithSuccess:(void(^)(NSArray *results))aSuccessHandler
                 failure:(void(^)(NSError *error))aFailureHandler;

+(id)fromSetterValue:(id)aValue;

@end
