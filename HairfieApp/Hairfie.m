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

-(NSString *)pictureUrlwithWidth:(NSString *)width andHeight:(NSString *)height {
    NSString  *url = [[picture objectForKey:@"publicUrl"] stringByAppendingString:@"?"];
    if(width)  url = [NSString stringWithFormat:@"%@&width=%@", url, width];
    if(height) url = [NSString stringWithFormat:@"%@&height=%@", url, height];
    
    return url;
}

- (void) setBusiness:(NSDictionary *) businessDic
{
    if([businessDic isKindOfClass:[NSNull class]]) return;
    
    _business = [[Business alloc] initWithDictionary:businessDic];
}

-(NSString *)pictureUrl {
    return [self pictureUrlwithWidth:nil andHeight:nil];
}

-(NSString *)hairfieCellUrl {
    return [self pictureUrlwithWidth:@"300" andHeight:@"420"];
}

-(NSString *)hairfieDetailUrl {
    return [self pictureUrlwithWidth:@"640" andHeight:@"710"];
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
                      limit:(NSNumber *)limit
                       skip:(NSNumber *)skip
                    success:(void(^)(NSArray *hairfies))aSuccessHandler
                    failure:(void(^)(NSError *error))aFailureHandler
{
    NSDictionary *parameters = @{
        @"filter": @{
            @"where": @{@"businessId": businessId},
            @"limit": limit,
            @"skip": skip
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
