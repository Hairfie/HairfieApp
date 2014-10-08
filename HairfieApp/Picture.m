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
    return [self initWithName:[aDictionary objectForKey:@"name"]
                    container:[aDictionary objectForKey:@"container"]
                          url:[aDictionary objectForKey:@"url"]];
}

-(id)initWithUrl:(NSString *)anUrl
{
    return [self initWithName:nil container:nil url:anUrl];
}

-(id)initWithName:(NSString *)aName
        container:(NSString *)aContainer
              url:(NSString *)anUrl
{
    self = [super init];
    if (self) {
        self.name = aName;
        self.container = aContainer;
        self.url = anUrl;
    }
    return self;
}

-(NSString *)toApiValue
{
    if ([self.name length] == 0) {
        return self.url;
    } else {
        return self.name;
    }
}

-(NSString *)urlWithWidth:(NSNumber *)aWidth
                   height:(NSNumber *)anHeight
{    
    if (aWidth && anHeight) {
        return [NSString stringWithFormat:@"%@?width=%@&height=%@", self.url, aWidth, anHeight];
    }
    
    if (aWidth) {
        return [NSString stringWithFormat:@"%@?width=%@", self.url, aWidth];
    }
    
    if (anHeight) {
        return [NSString stringWithFormat:@"%@?height=%@", self.url, anHeight];
    }
    
    return self.url;
}

@end
