//
//  Business.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Business.h"
#import "Address.h"
#import "GeoPoint.h"
#import "AppDelegate.h"

@implementation Business



-(NSString *)displayNameAndAddress {
    return [NSString stringWithFormat:@"%@ - %@", self.name, self.address.displayAddress];
}

-(id)initWithJson:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.id = [data valueForKey:@"id"];
        self.name = [data valueForKey:@"name"];
        self.gps = [[GeoPoint alloc] initWithJson:[data valueForKey:@"gps"]];
        self.address = [[Address alloc] initWithJson:[data valueForKey:@"address"]];
        self.distance = [data valueForKey:@"distance"];
        self.thumbnail = [data valueForKey:@"thumbnail"];
        self.pictures = [data valueForKey:@"pictures"];
        self.phoneNumbers = [data valueForKey:@"phoneNumbers"];
        self.timetable = [data valueForKey:@"timetable"];
        self.crossSell = [[data valueForKey:@"crossSell"] isEqualToNumber:@1];
        
        // mocked values
        self.prices = nil;
        self.numReviews = @3;
        self.rating = @80;
     }
    return self;
}

-(NSNumber *)ratingBetween:(NSNumber *)theMin
                       and:(NSNumber *)theMax
{
    if ([self.rating isEqual:nil]) {
        return nil;
    }
    
    return [[NSNumber alloc] initWithFloat:[self.rating floatValue] * [theMax floatValue] / 100];
}

+(void)listNearby:(GeoPoint *)aGeoPoint
            query:(NSString *)aQuery
            limit:(NSNumber *)aLimit
          success:(void(^)(NSArray *business))aSuccessHandler
          failure:(void(^)(NSError *error))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/nearby" verb:@"GET"] forMethod:@"businesses.nearby"];
    LBModelRepository *businessData = [[AppDelegate lbAdaptater] repositoryWithModelName:@"businesses"];
    [businessData invokeStaticMethod:@"nearby"
                          parameters:@{@"here": [aGeoPoint asApiString], @"limit" : aLimit, @"query" : aQuery}
                             success:^(NSArray *results) {
                                 NSMutableArray *businesses = [[NSMutableArray alloc] init];
                                 for (NSDictionary *result in results) {
                                     [businesses addObject:[[Business alloc] initWithJson:result]];
                                 }
                                 
                                 aSuccessHandler([[NSArray alloc] initWithArray: businesses]);
                             }
                             failure:^(NSError *error) {
                                 aFailureHandler(error);
                             }];
}


+(void)listSimilarTo:(NSString *)aBusinessId
               limit:(NSNumber *)aLimit
             success:(void(^)(NSArray *businesses))aSuccessHandler
             failure:(void(^)(NSError *error))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/:businessId/similar" verb:@"GET"]
                                        forMethod:@"businesses.similar"];
    LBModelRepository *businessData = [[AppDelegate lbAdaptater] repositoryWithModelName:@"businesses"];
    [businessData invokeStaticMethod:@"similar"
                          parameters:@{@"businessId": aBusinessId, @"limit" : aLimit}
                             success:^(NSArray *results) {
                                 NSMutableArray *businesses = [[NSMutableArray alloc] init];
                                 for (NSDictionary *result in results) {
                                     [businesses addObject:[[Business alloc] initWithJson:result]];
                                 }
                                 
                                 aSuccessHandler([[NSArray alloc] initWithArray: businesses]);
                             }
                             failure:^(NSError *error) {
                                 aFailureHandler(error);
                             }];
}


/* Temporary internal method to generate sample businesses */
+(id)sample
{
    Business *business = [[Business alloc] init];
    business.name = @"Some name";
    business.address = [[Address alloc] initWithStreet:@"123 foo street" city:@"Paris" zipCode:@"75000" country:@"FR"];
    business.distance = @534;
    business.thumbnail = @"http://maps.googleapis.com/maps/api/streetview?size=600x400&location=48.8698174,2.2984027";
    
    return business;
}

@end