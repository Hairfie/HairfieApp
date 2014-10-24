//
//  Service.m
//  HairfieApp
//
//  Created by Antoine Hérault on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Service.h"
#import "SetterUtils.h"

@implementation Service

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

-(NSDictionary*)toDictionary
{
    return [[NSDictionary alloc]initWithObjectsAndKeys:self.label, @"label",[self.price toDictionary], @"price", nil];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

@end
