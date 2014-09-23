//
//  Service.h
//  HairfieApp
//
//  Created by Antoine Hérault on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Money.h"

@interface Service : NSObject

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) Service *price;

-(id)initWithDictionary:(NSDictionary *)aDictionary;

-(id)initWithLabel:(NSString *)aLabel
             price:(Service *)aPrice;

@end
