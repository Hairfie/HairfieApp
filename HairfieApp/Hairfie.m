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

@synthesize id, description, price, picture, author = _author, business = _business, numLikes = _numLikes;

-(id)initWithDictionary:(NSDictionary *)data
{
    return (Hairfie*)[[Hairfie repository] modelWithDictionary:data];
}

- (void)setAuthor:(NSDictionary *)authorDic
{
    if([authorDic isKindOfClass:[NSNull class]]) return;
    
    _author = [[User alloc] initWithJson:authorDic];
}

- (void)setBusiness:(NSDictionary *) businessDic
{
    if([businessDic isKindOfClass:[NSNull class]]) return;
    
    _business = [[Business alloc] initWithDictionary:businessDic];
}

-(NSString *)pictureUrlwithWidth:(NSString *)width andHeight:(NSString *)height {
    NSString  *url = [[picture objectForKey:@"publicUrl"] stringByAppendingString:@"?"];
    if(width)  url = [NSString stringWithFormat:@"%@&width=%@", url, width];
    if(height) url = [NSString stringWithFormat:@"%@&height=%@", url, height];
    
    return url;
}

-(NSString *)pictureUrl {
    return [self pictureUrlwithWidth:nil andHeight:nil];
}

-(NSString *)hairfieCellUrl {
    return [self pictureUrlwithWidth:@"300" andHeight:@"420"];
}

-(NSString *)hairfieDetailUrl {
    return [self pictureUrlwithWidth:@"640" andHeight:@"640"];
}


-(NSString *)displayPrice {
    if([price isEqual:[NSNull null]]) return @"";
    
    if([[price objectForKey:@"currency"] isEqual:@"EUR"]) return [NSString stringWithFormat:@"%@ €", [price objectForKey:@"amount"]];

    return @"";
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
    
    [parameters setObject:[self.picture objectForKey:@"picture"] forKey:@"picture"];

    if(self.price != nil) {
        [parameters setObject:self.price forKey:@"price"];
    }
    if(self.description != nil) {
        [parameters setObject:self.description forKey:@"description"];
    }
    if(self.authorString != nil) {
        [parameters setObject:self.authorString forKey:@"authorString"];
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
                                       [hairfies addObject:[repository modelWithDictionary:result]];
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
