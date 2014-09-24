//
//  BusinessClaim.m
//  HairfieApp
//
//  Created by Leo Martin on 23/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessClaim.h"
#import "BusinessClaimRepository.h"
#import "AppDelegate.h"


@implementation BusinessClaim


-(void)claimWithSuccess:(void(^)(NSDictionary *results))aSuccessHandler
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
        [parameters setObject:[self.gps toDictionary] forKey:@"gps"];
    
    if (self.phoneNumber != nil)
        [parameters setObject:self.phoneNumber forKey:@"phoneNumber"];
    
    if (self.timetable != nil)
        [parameters setObject:self.timetable forKey:@"timetable"];
    
    if (self.address != nil)
        [parameters setObject:[self.address toDictionary]  forKey:@"address"];
    
    if (self.desc != nil)
        [parameters setObject:self.desc forKey:@"description"];
    
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
    

    if (nil == self.id) {
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessclaims"
                                                                                     verb:@"POST"]
                                            forMethod:@"businessclaims"];
        LBModelRepository *repository = (LBModelRepository *)[[self class] repository];
        
        NSLog(@"parameters :%@", parameters);
        [repository invokeStaticMethod:@""
                                   parameters:parameters
                                      success:aSuccessHandler
                                      failure:aFailureHandler];
        
    } else {
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessclaims/:id"
                                                                                     verb:@"PUT"]
                                            forMethod:@"businessclaims.update"];
        
        
        [[self repository] invokeStaticMethod:@"update"
                                   parameters:parameters
                                      success:aSuccessHandler
                                      failure:aFailureHandler];
    }
}


+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[BusinessClaimRepository class]];
}

@end
