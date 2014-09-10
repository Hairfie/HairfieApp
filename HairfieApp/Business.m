//
//  Business.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Business.h"
#import "AppDelegate.h"

@implementation Business

@synthesize _id, name, address;

-(NSString *)displayAddress {
    return [NSString stringWithFormat:@"%@ %@", [address objectForKey:@"street"], [address objectForKey:@"city"]];
}

-(NSString *)displayNameAndAddress {
    return [NSString stringWithFormat:@"%@ %@", name, [self displayAddress]];
}

@end