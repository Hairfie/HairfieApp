//
//  GeoPoint.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "GeoPoint.h"

@implementation GeoPoint

-(id)initWithString:(NSString *)aString
{
    self = [super init];
    if (self) {
        // TODO: check there are two parts
        NSArray *parts = [aString componentsSeparatedByString:@","];
    
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        self.longitude = [formatter numberFromString:parts[0]];
        self.latitude = [formatter numberFromString:parts[1]];
    }
    return self;
}

-(id)initWithJson:(NSDictionary *)data
{
    return [self initWithLongitude:[data valueForKey:@"lng"]
                          latitude:[data valueForKey:@"lat"]];
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
        self.longitude = aLongitude;
        self.latitude = aLatitude;
    }
    return self;
}

-(NSNumber *)distanceTo:(GeoPoint *)point
{
    return [[NSNumber alloc] initWithDouble:[self.location distanceFromLocation:point.location]];
}

-(CLLocation *)location
{
    return [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
}

-(NSString *)asApiString
{
    return [[NSString alloc] initWithFormat:@"%@,%@", self.longitude, self.latitude];
}

@end
