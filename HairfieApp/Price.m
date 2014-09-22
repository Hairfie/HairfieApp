//
//  Price.m
//  HairfieApp
//
//  Created by Antoine Hérault on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Price.h"

@implementation Price

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return [self initWithLabel:[aDictionary objectForKey:@"label"]
                         price:[[Money alloc] initWithDictionary:[aDictionary objectForKey:@"price"]]];
}

-(id)initWithLabel:(NSString *)aLabel price:(Money *)aPrice
{
    self = [super init];
    if (self) {
        self.label = aLabel;
        self.price = aPrice;
    }
    return self;
}

@end
