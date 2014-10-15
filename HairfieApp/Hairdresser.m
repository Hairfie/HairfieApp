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

@implementation Hairdresser

-(void)setBusiness:(NSDictionary *)aBusiness
{
    if ([aBusiness isKindOfClass:[Business class]]) {
        _business = aBusiness;
    } else if ([aBusiness isEqual:[NSNull null]]) {
        _business = nil;
    } else {
        _business = [[Business alloc] initWithDictionary:aBusiness];
    }
}

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return (Hairdresser *)[[[self class] repository] modelWithDictionary:aDictionary];
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
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairdressers"
                                                                                     verb:@"POST"]
                                            forMethod:@"hairdressers.create"];

        [[[self class] repository] invokeStaticMethod:@"create"
                                           parameters:[self toDictionary]
                                              success:onSuccess
                                              failure:aFailureHandler];
    } else {
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairdressers/:id"
                                                                                     verb:@"PUT"]
                                            forMethod:@"hairdressers.update"];

        [[[self class] repository] invokeStaticMethod:@"update"
                                           parameters:[self toDictionary]
                                              success:onSuccess
                                              failure:aFailureHandler];
    }
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[HairdresserRepository class]];
}

@end
