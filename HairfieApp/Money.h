//
//  Money.h
//  HairfieApp
//
//  Created by Antoine Hérault on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Money : NSObject

@property (strong, nonatomic) NSNumber *amount;
@property (strong, nonatomic) NSString *currency;

-(id)initWithDictionary:(NSDictionary *)aDictionary;

-(id)initWithAmount:(NSNumber *)anAmount
           currency:(NSString *)aCurrency;

-(NSDictionary *)toDictionary;

-(NSString *)formatted;

@end
