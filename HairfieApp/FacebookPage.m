//
//  FacebookPage.m
//  HairfieApp
//
//  Created by Leo Martin on 1/5/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "FacebookPage.h"
#import "SetterUtils.h"

@implementation FacebookPage


+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

-(id)initWithDictionary:(NSDictionary *)data
{
    return [self initWithName:[data valueForKey:@"name"]];

}


-(id)initWithName:(NSString *)aName
{
    self = [super init];
    if (self) {
        self.name = aName;
    }
    return self;
}




@end
