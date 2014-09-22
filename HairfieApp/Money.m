//
//  Money.m
//  HairfieApp
//
//  Created by Antoine Hérault on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Money.h"

@implementation Money

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return [self initWithAmount:[aDictionary objectForKey:@"amount"]
                       currency:[aDictionary objectForKey:@"currency"]];
}

-(id)initWithAmount:(NSNumber *)anAmount
           currency:(NSString *)aCurrency
{
    self = [super init];
    if (self) {
        self.amount = anAmount;
        self.currency = aCurrency;
    }
    return self;
}

-(NSString *)formatted
{
    if ([self.currency isEqualToString:@"EUR"]) {
        return [NSString stringWithFormat:@"%@ €", self.amount];
    } else {
        return [NSString stringWithFormat:@"%@ %@", self.currency, self.amount];
    }
}

@end
