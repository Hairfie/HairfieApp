//
//  Hairdresser.m
//  HairfieApp
//
//  Created by Leo Martin on 01/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Hairdresser.h"

@implementation Hairdresser


-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return [self initWithFirstName:[aDictionary objectForKey:@"firstName"]
                          lastName:[aDictionary objectForKey:@"lastName"]
                             email:[aDictionary objectForKey:@"email"]
                       phoneNumber:[aDictionary objectForKey:@"phoneNumber"]];
}

-(id)initWithFirstName:(NSString*)aFirstName
              lastName:(NSString*)aLastName
                 email:(NSString*)anEmail
           phoneNumber:(NSString*)aPhoneNumber
{
    self = [super init];
    if (self) {
        self.firstName = aFirstName;
        self.lastName = aLastName;
        self.email = anEmail;
        self.phoneNumber = aPhoneNumber;
    }
    return self;
}



-(NSDictionary*)toDictionary
{
    return [[NSDictionary alloc]initWithObjectsAndKeys:self.firstName, @"firstName",self.lastName, @"lastName", self.email,@"email", self.phoneNumber, @"phoneNumber", nil];
}

@end
