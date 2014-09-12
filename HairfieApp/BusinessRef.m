//
//  BusinessRef.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessRef.h"

@implementation BusinessRef

-(id)initWithId:(NSString *)anId
           name:(NSString *)aName
        address:(Address *)anAddress
{
    self = [super init];
    if (self) {
        self.id = anId;
        self.name = aName;
        self.address = anAddress;
    }
    return self;
}


@end
