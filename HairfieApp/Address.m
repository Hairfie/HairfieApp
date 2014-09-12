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
                        country:@"FR"]; // TODO: remove this hardcoded value!
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

@end