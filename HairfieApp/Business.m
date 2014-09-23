//
//  Business.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Business.h"
#import "BusinessRepository.h"
#import "Address.h"
#import "GeoPoint.h"
#import "AppDelegate.h"
#import "Service.h"

@implementation Business

-(NSString *)displayNameAndAddress
{
    return [NSString stringWithFormat:@"%@ - %@", self.name, self.address.displayAddress];
}

-(NSString *)displayNumHairfies
{
    if ([self.numHairfies integerValue] > 1) {
        return [NSString stringWithFormat:@"%@ hairfies", self.numHairfies];
    } else {
        return [NSString stringWithFormat:@"%@ hairfie", self.numHairfies];
    }
}

-(id)initWithDictionary:(NSDictionary *)data
{
    self = [super init];

    self.numReviews = @3;
    self.rating = @80;

    self = (Business*)[[Business repository] modelWithDictionary:data];
    
    // seems there is a parser issue with boolean values...
    if ([[data objectForKey:@"crossSell"] isEqualToNumber:@1]) {
        self.crossSell = YES;
    } else {
        self.crossSell = NO;
    }
    
    return self;
}

- (void)setAddress:(NSDictionary *)addressDic
{
    if([addressDic isKindOfClass:[NSNull class]]) return;

    _address = [[Address alloc] initWithJson:addressDic];
}

- (void)setGps:(NSDictionary *)geoPointDic
{
    if([geoPointDic isKindOfClass:[NSNull class]]) return;

    _gps = [[GeoPoint alloc] initWithJson:geoPointDic];
}

-(void)setServices:(NSArray *)services
{
    if ([services isEqual:[NSNull null]]) {
        _services = @[];
    } else {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSDictionary *price in services) {
            [temp addObject:[[Service alloc] initWithDictionary:price]];
        }
        _services = [[NSArray alloc] initWithArray:temp];
    }
    
    NSLog(@"Prices loaded: %@", _services);
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
                                     [businesses addObject:[[Business alloc] initWithDictionary:result]];
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
                                     [businesses addObject:[[Business alloc] initWithDictionary:result]];
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

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[BusinessRepository class]];
}

@end