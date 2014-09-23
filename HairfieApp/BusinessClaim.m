//
//  BusinessClaim.m
//  HairfieApp
//
//  Created by Leo Martin on 23/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessClaim.h"
#import "AppDelegate.h"
#import "BusinessClaimRepository.h"

@implementation BusinessClaim


-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    if (nil != self.id) {
        [parameters setObject:self.id forKey:@"id"];
    }
    
    if (self.name != nil)
        [parameters setObject:self.name forKey:@"name"];
    if (self.kind != nil)
        [parameters setObject:self.kind forKey:@"kind"];
    if (self.gps != nil)
        [parameters setObject:self.gps forKey:@"gps"];
    if (self.phoneNumber != nil)
        [parameters setObject:self.phoneNumber forKey:@"phoneNumber"];
    if (self.timetable != nil)
        [parameters setObject:self.timetable forKey:@"timetable"];
    if (self.address != nil)
    {
        [parameters setObject:self.address forKey:@"address"];

    }
    if (self.pictures != nil)
        [parameters setObject:self.pictures forKey:@"pictures"];
    if (self.services != nil)
        [parameters setObject:self.services forKey:@"services"];
   
    if (self.men == YES)
        [parameters setObject:@true forKey:@"men"];
    else
        [parameters setObject:@false forKey:@"men"];
    
    if (self.women == YES)
        [parameters setObject:@true forKey:@"women"];
    else
        [parameters setObject:@false forKey:@"women"];
    
    if (self.children == YES)
        [parameters setObject:@true forKey:@"children"];
    else
        [parameters setObject:@false forKey:@"children"];
    
  
    
    void (^onSuccess)(NSDictionary *) = ^(NSDictionary *result) {
       
        aSuccessHandler();
    };
    
    if (nil == self.id) {
        NSLog(@"ICI %@", parameters);
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessClaims"
                                                                                     verb:@"POST"]
                                            forMethod:@"businessClaims.create"];
        
        [[self repository] invokeStaticMethod:@"create"
                                   parameters:parameters
                                      success:onSuccess
                                      failure:aFailureHandler];
    } else {
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessClaims/:id"
                                                                                     verb:@"PUT"]
                                            forMethod:@"businessClaims.update"];
        
        
        [[self repository] invokeStaticMethod:@"update"
                                   parameters:parameters
                                      success:onSuccess
                                      failure:aFailureHandler];
    }
}


+(BusinessClaimRepository *)repository
{
    return (BusinessClaimRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[BusinessClaimRepository class]];
}



@end
