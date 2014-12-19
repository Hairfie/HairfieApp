//
//  Hairdresser.m
//  HairfieApp
//
//  Created by Leo Martin on 01/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Hairdresser.h"
#import "AppDelegate.h"
#import "HairdresserRepository.h"
#import "SetterUtils.h"

@implementation Hairdresser

-(void)setBusiness:(id)aBusiness
{
    _business = [Business fromSetterValue:aBusiness];
}

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    self = (Hairdresser *)[[[self class] repository] modelWithDictionary:aDictionary];
    
    if ([[aDictionary valueForKey:@"active"] isEqualToNumber:@1])
        self.active = YES;
    else
        self.active = NO;
    
    return self;
}

-(NSString *)displayFullName
{
    return [NSString stringWithFormat:@"%@ %@",self.firstName, self.lastName];
}

-(NSDictionary *)toDictionary
{
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    
    if (nil != self.id) {
        [temp setObject:self.id forKey:@"id"];
    }

    [temp setObject:[NSNumber numberWithBool:self.active] forKey:@"active"];

    if (nil != self.business.id) {
        [temp setObject:self.business.id forKey:@"businessId"];
    }

    if (nil != self.firstName) {
        [temp setObject:self.firstName forKey:@"firstName"];
    }

    if (nil != self.lastName) {
        [temp setObject:self.lastName forKey:@"lastName"];
    }

    if (nil != self.email) {
        [temp setObject:self.email forKey:@"email"];
    }

    if (nil != self.phoneNumber) {
        [temp setObject:self.phoneNumber forKey:@"phoneNumber"];
    }
    
    if (self.active == YES)
        [temp setObject:@true forKey:@"active"];
    else
        [temp setObject:@false forKey:@"active"];

    [temp setObject:@false forKey:@"hidden"];

    if (nil != self.numHairfies){
        [temp setObject:self.numHairfies forKey:@"numHairfies"];
    }
    return [[NSDictionary alloc] initWithDictionary:temp];
}

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *))aFailureHandler
{
    void(^onSuccess)(NSDictionary *) = ^(NSDictionary *result) {
        if (nil == self.id) {
            self.id = [result objectForKey:@"id"];
        }
        aSuccessHandler();
    };
    
    if (nil == self.id) {
       
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessMembers"
                                                                                     verb:@"POST"]
                                            forMethod:@"hairdressers.create"];

        [[[self class] repository] invokeStaticMethod:@"create"
                                           parameters:[self toDictionary]
                                              success:onSuccess
                                              failure:aFailureHandler];
    } else {
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessMembers/:id"
                                                                                     verb:@"PUT"]
                                            forMethod:@"hairdressers.update"];

        [[[self class] repository] invokeStaticMethod:@"update"
                                           parameters:[self toDictionary]
                                              success:onSuccess
                                              failure:aFailureHandler];
    }
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[HairdresserRepository class]];
}

@end
