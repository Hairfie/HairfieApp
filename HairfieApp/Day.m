//
//  Day.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Day.h"

@implementation Day

@synthesize selector;

-(id)initWithName:(NSString *)aName andSelector:(NSString *)aSelector andInt:(NSNumber *)aDayInt
{
    self = [super init];
    if (self) {
        self.name       = aName;
        self.selector   = aSelector;
        self.dayInt     = aDayInt;
    }
    return self;
}

@end
