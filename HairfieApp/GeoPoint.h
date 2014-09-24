//
//  GeoPoint.h
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GeoPoint : NSObject

@property (strong, nonatomic) NSNumber *lng;
@property (strong, nonatomic) NSNumber *lat;

-(id)initWithString:(NSString *)aString;

-(id)initWithJson:(NSDictionary *)data;

-(id)initWithLocation:(CLLocation *)aLocation;

-(id)initWithLongitude:(NSNumber *)aLongitude
              latitude:(NSNumber *)aLatitude;



-(CLLocation *)location;

-(NSNumber *)distanceTo:(GeoPoint *)point;

-(NSString *)asApiString;
-(NSDictionary*)toDictionary;

@end
