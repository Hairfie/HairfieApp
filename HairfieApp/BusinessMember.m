//
//  BusinessMember.m
//  HairfieApp
//
//  Created by Leo Martin on 01/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessMember.h"
#import "AppDelegate.h"
#import "BusinessMemberRepository.h"
#import "SetterUtils.h"

@implementation BusinessMember

-(void)setBusiness:(id)aBusiness
{
    _business = [Business fromSetterValue:aBusiness];
}

-(void)setUser:(User *)anUser
{
    _user = [User fromSetterValue:anUser];
}

-(void)setPicture:(id)aPicture
{
    _picture = [Picture fromSetterValue:aPicture];
}

-(id)initWithDictionary:(NSDictionary *)aDictionary
{
    self = (BusinessMember *)[[[self class] repository] modelWithDictionary:aDictionary];
    
    if ([[aDictionary valueForKey:@"active"] isEqualToNumber:@1])
        self.active = YES;
    else
        self.active = NO;

    return self;
}

-(NSString *)displayFullName
{
    
    NSString *fullName = (self.lastName.length != 0) ? [NSString stringWithFormat:@"%@ %@.",self.firstName, [self.lastName substringToIndex:1]] : self.firstName;
    
    return fullName;
}

-(NSString *)displayHairfies
{
    if ([self.numHairfies integerValue] < 2) {
        return [NSString stringWithFormat:@"%@ hairfie", self.numHairfies];
    } else {
        return [NSString stringWithFormat:@"%@ hairfies", self.numHairfies];
    }
}


-(NSURL *)pictureUrlWithWidth:(NSNumber *)aWdith
                       height:(NSNumber *)anHeight
{
    if (nil == self.picture) return nil;
    
    
    
    return [self.picture urlWithWidth:aWdith height:anHeight];
    
    
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

    if (nil != self.user.id) {
        [temp setObject:self.user.id forKey:@"userId"];
    }

    if (nil != self.picture) {
        [temp setObject:[self.picture toApiValue] forKey:@"picture"];
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
                                            forMethod:@"businessMembers"];

        [[[self class] repository] invokeStaticMethod:@"create"
                                           parameters:[self toDictionary]
                                              success:onSuccess
                                              failure:aFailureHandler];
    } else {
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessMembers/:id"
                                                                                     verb:@"PUT"]
                                            forMethod:@"businessMembers.update"];

        [[[self class] repository] invokeStaticMethod:@"update"
                                           parameters:[self toDictionary]
                                              success:onSuccess
                                              failure:aFailureHandler];
    }
}

+(void)getById:(NSString *)aBusinessMemberId
   withSuccess:(void (^)(BusinessMember *))aSuccessHandler
       failure:(void (^)(NSError *))aFailureHandler
{
    // we can't simply rely on the findById method as we need to initialize
    // the result model using the initWithDictionary method
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businessMembers/:businessMemberId"
                                                                                 verb:@"GET"]
                                        forMethod:@"businessMembers.getById"];
    
    [[[self class] repository] invokeStaticMethod:@"getById"
                                       parameters:@{@"businessMemberId": aBusinessMemberId}
                                          success:^(id value) {
                                              aSuccessHandler([[[self class] alloc] initWithDictionary:value]);
                                          }
                                          failure:aFailureHandler];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[BusinessMemberRepository class]];
}

@end
