//
//  Hairfie.m
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Hairfie.h"
#import "UserRepository.h"
#import "BusinessRepository.h"
#import "AppDelegate.h"
#import "SetterUtils.h"

@implementation Hairfie

@synthesize description;

-(id)initWithDictionary:(NSDictionary *)data
{
    return (Hairfie*)[[Hairfie repository] modelWithDictionary:data];
}

-(void)setAuthor:(id)aUser
{
    _author = [User fromSetterValue:aUser];
}

-(void)setBusiness:(id)aBusiness
{
    _business = [Business fromSetterValue:aBusiness];
}

-(void)setPicture:(id)aPicture
{
    _picture = [Picture fromSetterValue:aPicture];
}

-(void)setPrice:(id)aPrice
{
    _price = [Money fromSetterValue:aPrice];
}

-(NSString *)pictureUrlwithWidth:(NSNumber *)width andHeight:(NSNumber *)height
{
    return [self.picture urlWithWidth:width height:height];
}

-(NSString *)pictureUrl
{
    return [self pictureUrlwithWidth:nil andHeight:nil];
}

-(NSString *)hairfieCellUrl
{
    return [self pictureUrlwithWidth:@300 andHeight:@420];
}

-(NSString *)hairfieDetailUrl
{
    return [self pictureUrlwithWidth:@640 andHeight:@640];
}

-(NSString *)displayPrice
{
    if([self.price isEqual:[NSNull null]]) return @"";
    
    return self.price.formatted;
}

-(NSString *)displayNumLikes {
    return [NSString stringWithFormat:@"%@", _numLikes];
}

-(NSString *)displayNumComments {
    return [NSString stringWithFormat:@"%@", _numComments];
}


+ (void) listLatest:(NSNumber *)limit
               skip:(NSNumber *)skip
            success:(void (^)(NSArray *))aSuccessHandler
            failure:(void (^)(NSError *))aFailureHandler {
    
        NSDictionary *parameters = @{
             @"filter": @{
                     @"limit": limit,
                     @"skip": skip,
                     @"order": @"createdAt DESC"
             }
        };
        
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies" verb:@"GET"]
                                            forMethod:@"hairfies.find"];
        
        LBModelRepository *repository = [self repository];
        
        [repository invokeStaticMethod:@"find"
                            parameters:parameters
                               success:^(NSArray *results) {
                                   NSMutableArray *hairfies = [[NSMutableArray alloc] init];
                                   for (NSDictionary *result in results) {
                                       [hairfies addObject:[[[self class] alloc] initWithDictionary:result]];
                                   }
                                   aSuccessHandler([[NSArray alloc] initWithArray:hairfies]);
                               }
                               failure:aFailureHandler];
}

+(void)listLatestPerPage:(NSNumber *)page
                    success:(void(^)(NSArray *hairfies))aSuccessHandler
                    failure:(void(^)(NSError *error))aFailureHandler {
    NSNumber *limit = @(HAIRFIES_PAGE_SIZE);
    NSNumber *offset = @([page integerValue] * [limit integerValue]);
    
    [self listLatest:limit skip:offset success:aSuccessHandler failure:aFailureHandler];
    
}



+(void)listLatestByBusiness:(NSString *)businessId
                      until:(NSDate *)until
                      limit:(NSNumber *)limit
                       skip:(NSNumber *)skip
                    success:(void(^)(NSArray *hairfies))aSuccessHandler
                    failure:(void(^)(NSError *error))aFailureHandler
{
    NSMutableDictionary *where = [[NSMutableDictionary alloc] initWithDictionary:@{@"businessId": businessId}];
    
    if (nil != until) {
        [where setObject:@{@"lte": until} forKey:@"createdAt"];
    }
    
    NSDictionary *parameters = @{
        @"filter": @{
            @"where":where,
            @"limit": limit,
            @"skip": skip,
            @"order": @"createdAt DESC"
        }
    };
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies" verb:@"GET"]
                                        forMethod:@"hairfies.find"];
    
    LBModelRepository *repository = [self repository];
    
    [repository invokeStaticMethod:@"find"
                        parameters:parameters
                           success:^(NSArray *results) {
                               NSMutableArray *hairfies = [[NSMutableArray alloc] init];
                                for (NSDictionary *result in results) {
                                    [hairfies addObject:[repository modelWithDictionary:result]];
                                }
                               aSuccessHandler([[NSArray alloc] initWithArray:hairfies]);
                            }
                            failure:aFailureHandler];
}

+(id)fromSetterValue:(id)aValue
{
    return [SetterUtils getInstanceOf:[self class] fromSetterValue:aValue];
}

+(HairfieRepository *)repository
{
    return (HairfieRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
}

@end
