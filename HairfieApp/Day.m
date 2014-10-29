//
//  Day.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Day.h"

@implementation Day

-(id)initWithName:(NSString *)aName andSelectorName:(NSString *)aSelector andInt:(NSNumber *)aDayInt
{
    self = [super init];
    if (self) {
        self.name           = aName;
        self.selectorName   = aSelector;
        self.dayInt         = aDayInt;
    }
    return self;
}

-(SEL)selector {
    return NSSelectorFromString(self.selectorName);
}

@end
