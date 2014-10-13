//
//  Address.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Address.h"

// TODO: use a struct?
@implementation Address

-(id)initWithJson:(NSDictionary *)data
{
    return [self initWithStreet:[data valueForKey:@"street"]
                           city:[data valueForKey:@"city"]
                        zipCode:[data valueForKey:@"zipCode"]
                        country:[data valueForKey:@"country"]];
}

-(id)initWithStreet:(NSString *)aStreet
               city:(NSString *)aCity
            zipCode:(NSString *)aZipCode
            country:(NSString *)aCountry
{
    self = [super init];
    if (self) {
        self.street = aStreet;
        self.city = aCity;
        self.zipCode = aZipCode;
        self.country = aCountry;
    }
    return self;
}

-(NSString *)displayAddress
{
    return [NSString stringWithFormat:@"%@ %@ %@", self.street, self.zipCode, self.city];
}

-(NSDictionary*)toDictionary
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:self.country, @"country", self.zipCode, @"zipCode", self.city, @"city", self.street, @"street", nil];
}

@end