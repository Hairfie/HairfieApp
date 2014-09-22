//
//  Price.h
//  HairfieApp
//
//  Created by Antoine Hérault on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Money.h"

@interface Price : NSObject

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) Money *price;

-(id)initWithDictionary:(NSDictionary *)aDictionary;

-(id)initWithLabel:(NSString *)aLabel
             price:(Money *)aPrice;

@end
