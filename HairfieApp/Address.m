//
//  Address.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Address.h"
#import "SetterUtils.h"

// TODO: use a struct?
@implementation Address

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return [self initWithStreet:[aDictionary valueForKey:@"street"]
                           city:[aDictionary valueForKey:@"city"]
                        zipCode:[aDictionary valueForKey:@"zipCode"]
                        country:[aDictionary valueForKey:@"country"]];
}

-(id)initWithJson:(NSDictionary *)data
{
    return [self initWithDictionary:data];
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

-(NSString *)displayQueryAddress
{
    
    NSString *streetForquery = [self.street stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    return [NSString stringWithFormat:@"%@,+%@,+%@", streetForquery, self.zipCode, self.city];
}

-(NSString*)displayCityAndZipCode
{
    return [NSString stringWithFormat:@"%@ %@", self.zipCode, self.city];
}

-(NSDictionary*)toDictionary
{
    return [[NSDictionary alloc] initWithObjectsAndKeys:self.country, @"country", self.zipCode, @"zipCode", self.city, @"city", self.street, @"street", nil];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

@end