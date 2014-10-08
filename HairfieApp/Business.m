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
    if ([aDictionary isKindOfClass:[Timetable class]]) {
        _timetable = aDictionary;
    } else if ([aDictionary isEqual:[NSNull null]]) {
        _timetable = nil;
    } else {
        _timetable = [[Timetable alloc] initWithDictionary:aDictionary];
    }
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

-(void)setServices:(NSMutableArray *)services
{
    if ([services isEqual:[NSNull null]]) {
        _services = nil;
    } else {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSDictionary *service in services) {
            if ([service isKindOfClass:[Service class]]) {
                [temp addObject:service];
            } else {
                [temp addObject:[[Service alloc] initWithDictionary:service]];
            }
        }
        _services = temp;
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

-(void)setPictures:(NSMutableArray *)pictures
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *picture in pictures) {
        [temp addObject:[[Picture alloc] initWithDictionary:picture]];
    }
    _pictures = [[NSMutableArray alloc] initWithArray:temp];
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


-(void)updateWithSuccess:(void(^)(NSArray *results))aSuccessHandler
                 failure:(void(^)(NSError *error))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/:id" verb:@"PUT"] forMethod:@"businesses.update"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    
    [parameters setObject:self.id forKey:@"id"];
    
    if (self.name != nil)
        [parameters setObject:self.name forKey:@"name"];
    
    if (self.gps != nil)
        [parameters setObject:[self.gps toDictionary] forKey:@"gps"];
    
    if (self.phoneNumber != nil)
        [parameters setObject:self.phoneNumber forKey:@"phoneNumber"];
    
    if (self.timetable != nil)
        [parameters setObject:[self.timetable toDictionary] forKey:@"timetable"];
    
    if (self.address != nil)
        [parameters setObject:[self.address toDictionary]  forKey:@"address"];
    
    if (self.desc != nil)
        [parameters setObject:self.desc forKey:@"description"];
    
    if (self.pictures != nil)
        [parameters setObject:self.pictures forKey:@"pictures"];
    
    if (self.services != nil)
        [parameters setObject:self.services forKey:@"services"];
    
    
    [[Business repository] invokeStaticMethod:@"update" parameters:parameters success:aSuccessHandler failure:aFailureHandler];
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