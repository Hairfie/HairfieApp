//
//  BusinessSearch.m
//  HairfieApp
//
//  Created by Antoine Hérault on 06/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessSearch.h"
#import "AppDelegate.h"

@implementation BusinessSearch
{
    GeoPoint *whereGeoPoint;
}

-(NSString *)display
{
    if (0 == [self.query length] && 0 == [self.where length]) {
        // around me
        return NSLocalizedStringFromTable(@"HAIRDRESSER AROUND YOU", @"BusinessSearch", nil);
    } else if (0 != [self.query length] && 0 == [self.where length]) {
        // search query around me
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ AROUND YOU", @"BusinessSearch", nil), [self.query uppercaseString]];
    } else if (0 == [self.query length] && 0 != [self.where length]) {
        // around specified location
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"HAIRDRESSER NEAR %@", @"BusinessSearch", nil), [self.where uppercaseString]];
    } else {
        // search query around specified location
        return [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ NEAR %@", @"BusinessSearch", nil), [self.query uppercaseString], [self.where uppercaseString]];
    }
}

-(NSString *)changedEventName
{
    return @"BusinessSearch.changed";
}

-(void)setQuery:(NSString *)query
{
    _query = query;
    [self notifyChange];
}

-(void)setWhere:(NSString *)where
{
    _where = where;
    whereGeoPoint = nil;
    
    if (![where isEqualToString:@""]) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:where completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark* placemark in placemarks) {
                whereGeoPoint = [[GeoPoint alloc] initWithLocation:placemark.location];
            }
            [self notifyChange];
        }];
    }
}

-(GeoPoint *)whereGeoPoint
{
    if (nil == whereGeoPoint) {
        return self.currentUserLocation;
    }
    
    return whereGeoPoint;
}

-(BOOL)isAroundMe
{
    return 0 == [self.where length];
}

-(GeoPoint *)currentUserLocation
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return appDelegate.currentLocation;
}

-(void)notifyChange
{
    [[NSNotificationCenter defaultCenter] postNotificationName:self.changedEventName object:self];
}

@end
