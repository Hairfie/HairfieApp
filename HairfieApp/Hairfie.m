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

@implementation Hairfie

@synthesize description;

-(id)initWithDictionary:(NSDictionary *)data
{
    return (Hairfie*)[[Hairfie repository] modelWithDictionary:data];
}

- (void)setAuthor:(NSDictionary *)anAuthor
{
    if ([anAuthor isKindOfClass:[User class]]) {
        _author = anAuthor;
    } else if ([anAuthor isEqual:[NSNull null]]) {
        _author = nil;
    } else {
        _author = [[User alloc] initWithDictionary:anAuthor];
    }
}

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

-(void)setPicture:(NSDictionary *)aPicture
{
    if ([aPicture isKindOfClass:[Picture class]]) {
        _picture = aPicture;
    } else if ([aPicture isEqual:[NSNull null]]) {
        _picture = nil;
    } else {
        _picture = [[Picture alloc] initWithDictionary:aPicture];
    }
}

-(void)setPrice:(NSDictionary *)aPrice
{
    if ([aPrice isKindOfClass:[Money class]]) {
        _price = aPrice;
    } else if ([aPrice isEqual:[NSNull null]]) {
        _price = aPrice;
    } else {
        _price = [[Money alloc] initWithDictionary:aPrice];
    }
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

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler
{
    void (^onSuccess)(NSDictionary *) = ^(NSDictionary *result) {
        aSuccessHandler();
    };
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setObject:[self.picture toApiValue] forKey:@"picture"];

    if(self.price != nil) {
        [parameters setObject:self.price.toDictionary forKey:@"price"];
    }
    if(self.description != nil) {
        [parameters setObject:self.description forKey:@"description"];
    }
    if(self.hairdresserName != nil) {
        [parameters setObject:self.hairdresserName forKey:@"hairdresserName"];
    }
    if(self.business != nil) {
        [parameters setObject:self.business.id forKey:@"businessId"];
    }
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/hairfies"
                                                                                     verb:@"POST"]
                                        forMethod:@"hairfies.create"];
    LBModelRepository *repository = (LBModelRepository *)[[self class] repository];
    
    [repository invokeStaticMethod:@"create"
                                   parameters:parameters
                                      success:onSuccess
                                      failure:aFailureHandler];
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

+(HairfieRepository *)repository
{
    return (HairfieRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
}

@end
