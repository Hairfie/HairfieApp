//
//  Service.m
//  HairfieApp
//
//  Created by Antoine Hérault on 22/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Service.h"
#import "SetterUtils.h"
#import "AppDelegate.h"
#import "ServiceRepository.h"

@implementation Service

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    return [self initWithLabel:[aDictionary objectForKey:@"label"]
                         price:[[Money alloc] initWithDictionary:[aDictionary objectForKey:@"price"]]
                      duration:[aDictionary objectForKey:@"durationMinutes"]
                    businessId:[aDictionary objectForKey:@"businessId"]
            
            ];
}

-(id)initWithLabel:(NSString *)aLabel price:(Money *)aPrice duration:(NSNumber *)aDuration businessId:(NSString*)aBusinessId
{
    self = [super init];
    if (self) {
        self.label = aLabel;
        self.price = aPrice;
        self.durationMinutes = aDuration;
        self.businessId = aBusinessId;
    }
    return self;
}

-(NSDictionary*)toDictionary
{
    return [[NSDictionary alloc]initWithObjectsAndKeys:self.label, @"label",[self.price toDictionary], @"price",self.businessId, @"businessId", self.durationMinutes, @"durationMinutes", self.id, @"id", nil];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

-(void)saveWithSuccess:(void(^)(NSDictionary* result))aSuccessHandler
               failure:(void(^)(NSError *))aFailureHandler
{
    void(^onSuccess)(NSDictionary *) = ^(NSDictionary *result) {
        if (nil == self.id) {
            self.id = [result objectForKey:@"id"];
        }
        aSuccessHandler(result);
    };
    if (nil == self.id) {
        
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessServices/"
                                                                                     verb:@"POST"]
                                            forMethod:@"businessServices"];
        
        [[[self class] repository] invokeStaticMethod:@""
                                           parameters:[self toDictionary]
                                              success:onSuccess
                                              failure:aFailureHandler];
    } else {
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessServices/:id"
                                                                                     verb:@"PUT"]
                                            forMethod:@"businessServices.update"];
        
        [[[self class] repository] invokeStaticMethod:@"update"
                                           parameters:[self toDictionary]
                                              success:onSuccess
                                              failure:aFailureHandler];
    }
}

+(ServiceRepository *)repository
{
    return (ServiceRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[ServiceRepository class]];
}



@end
