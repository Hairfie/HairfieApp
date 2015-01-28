//
//  GeoPoint.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "GeoPoint.h"
#import "SetterUtils.h"

@implementation GeoPoint

-(id)initWithString:(NSString *)aString
{
    self = [super init];
    if (self) {
        // TODO: check there are two parts
        NSArray *parts = [aString componentsSeparatedByString:@","];
    
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [formatter setLocale:usLocale];
        self.lng = [formatter numberFromString:parts[0]];
        self.lat = [formatter numberFromString:parts[1]];
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)data
{
    return [self initWithLongitude:[data valueForKey:@"lng"]
                          latitude:[data valueForKey:@"lat"]];
}

-(id)initWithJson:(NSDictionary *)data
{
    return [self initWithDictionary:data];
}

-(id)initWithLocation:(CLLocation *)aLocation
{
    return [self initWithLongitude:[[NSNumber alloc] initWithDouble:aLocation.coordinate.longitude]
                          latitude:[[NSNumber alloc] initWithDouble:aLocation.coordinate.latitude]];
}

-(id)initWithLongitude:(NSNumber *)aLongitude
              latitude:(NSNumber *)aLatitude
{
    self = [super init];
    if (self) {
        self.lng = aLongitude;
        self.lat = aLatitude;
    }
    return self;
}

-(void)setLat:(NSNumber *)aLat
{
    _lat = aLat;
}

-(void)setLng:(NSNumber *)aLng
{
    _lng = aLng;
}

-(NSNumber *)distanceTo:(GeoPoint *)point
{
    return [[NSNumber alloc] initWithDouble:[self.location distanceFromLocation:point.location]];
}

-(CLLocation *)location
{
    return [[CLLocation alloc] initWithLatitude:[self.lat doubleValue] longitude:[self.lng doubleValue]];
}

-(NSDictionary *)toApiValue
{
    return [self toDictionary];
}

-(NSDictionary*)toDictionary
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:self.lng, @"lng", self.lat, @"lat",nil];
}

-(BOOL)isNotValid {
    if(!self.lat || !self.lng) {
        return YES;
    } else {
        return NO;
    }
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

@end
