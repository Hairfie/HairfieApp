//
//  Picture.m
//  HairfieApp
//
//  Created by Antoine Hérault on 11/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Picture.h"

@implementation Picture

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return [self initWithUrl:[aDictionary objectForKey:@"publicUrl"]];
}

-(id)initWithUrl:(NSString *)anUrl
{
    self = [super init];
    if (self) {
        self.url = anUrl;
    }
    return self;
}

@end
