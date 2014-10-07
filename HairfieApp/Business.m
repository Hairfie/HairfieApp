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
#import "Picture.h"

@implementation Business

-(void)setOwner:(NSDictionary *)aDictionary
{
    if ([aDictionary isKindOfClass:[User class]]) {
        _owner = aDictionary;
    } else if ([aDictionary isEqual:[NSNull null]]) {
        _owner = nil;
    } else {
        _owner = [[User alloc] initWithDictionary:aDictionary];
    }
}

-(void)setTimetable:(NSDictionary *)aDictionary
{
    if (nil == aDictionary || [aDictionary isEqual:[NSNull null]]) return;
    _timetable = [[Timetable alloc] initWithDictionary:aDictionary];
}

-(void)setThumbnail:(NSDictionary *)aThumbnail
{
    if ([aThumbnail isKindOfClass:[Picture class]]) {
        _thumbnail = aThumbnail;
    } else if ([aThumbnail isEqual:[NSNull null]]) {
        _thumbnail = nil;
    } else {
        _thumbnail = [[Picture alloc] initWithDictionary:aThumbnail];
    }
}

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

    self = (Business*)[[Business repository] modelWithDictionary:data];

    // seems there is a parser issue with boolean values...
    if ([[data objectForKey:@"crossSell"] isEqualToNumber:@1]) {
        self.crossSell = YES;
    } else {
        self.crossSell = NO;
    }

    return self;
}

-(void)setPictures:(NSArray *)pictures
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *picture in pictures) {
        [temp addObject:[[Picture alloc] initWithDictionary:picture]];
    }
    _pictures = [[NSArray alloc] initWithArray:temp];
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

-(NSString *)thumbUrl
{
    return [self.thumbnail urlWithWidth:@100 height:@100];
}

-(NSNumber *)ratingBetween:(NSNumber *)theMin // TODO: scale from the min
                       and:(NSNumber *)theMax
{
    if ([self.rating isEqual:[NSNull null]]) {
        return nil;
    }

    return [[NSNumber alloc] initWithFloat:[self.rating floatValue] * [theMax floatValue] / 100];
}

-(NSNumber *)distanceTo:(GeoPoint *)aGeoPoint
{
    return [self.gps distanceTo:aGeoPoint];
}

+(void)listNearby:(GeoPoint *)aGeoPoint
            query:(NSString *)aQuery
            limit:(NSNumber *)aLimit
          success:(void(^)(NSArray *business))aSuccessHandler
          failure:(void(^)(NSError *error))aFailureHandler
{
    if (nil == aQuery) {
        aQuery = @"";
    }

    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/nearby" verb:@"GET"] forMethod:@"businesses.nearby"];
    LBModelRepository *businessData = [[AppDelegate lbAdaptater] repositoryWithModelName:@"businesses"];
    [businessData invokeStaticMethod:@"nearby"
                          parameters:@{@"here": aGeoPoint.asApiString, @"limit" : aLimit, @"query" : aQuery}
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

+(void)getById:(NSString *)anId
   withSuccess:(void (^)(Business *))aSuccessHandler
       failure:(void (^)(NSError *))aFailureHandler
{
    // we can't simply rely on the findById method as we need to initialize
    // the result model using the initWithDictionary method
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/:businessId"
                                                                                 verb:@"GET"]
                                        forMethod:@"businesses.getById"];

    [[[self class] repository] invokeStaticMethod:@"getById"
                                       parameters:@{@"businessId": anId}
                                          success:^(id value) {
                                              aSuccessHandler([[[self class] alloc] initWithDictionary:value]);
                                          }
                                          failure:aFailureHandler];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[BusinessRepository class]];
}

@end