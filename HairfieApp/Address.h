//
//  Address.h
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *country;

-(id)initWithJson:(NSDictionary *)data;

-(id)initWithStreet:(NSString *)aStreet
                city:(NSString *)aCity
             zipCode:(NSString *)aZipCode
             country:(NSString *)aCountry;

-(NSString *)displayAddress;

@end