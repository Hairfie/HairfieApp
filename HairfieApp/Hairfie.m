//
//  Hairfie.m
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "Hairfie.h"
#import "HairfieRepository.h"
#import "UserRepository.h"
#import "BusinessRepository.h"
#import "AppDelegate.h"

@implementation Hairfie

@synthesize description, hairfieId, businessId, price, picture, user = _user, business = _business, numLikes = _numLikes;


- (void) setUser:(NSDictionary *) userDic {
    
    UserRepository *userRepository = (UserRepository *)[[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
    _user = (User *)[userRepository modelWithDictionary:userDic];
}

-(void) setNumLikes:(NSString *)numLikes {
    NSLog(@"numlikes : %@", numLikes);
    _numLikes = @"0";
}

-(NSString *)pictureUrlwithWidth:(NSString *)width andHeight:(NSString *)height {
    NSString  *url = [[picture objectForKey:@"publicUrl"] stringByAppendingString:@"?"];
    if(width)  url = [NSString stringWithFormat:@"%@&width=%@", url, width];
    if(height) url = [NSString stringWithFormat:@"%@&height=%@", url, height];
    
    return url;
}

- (void) setBusiness:(NSDictionary *) businessDic {
    if([businessDic isKindOfClass:[NSNull class]]) {
        
    } else {
        _business = [[Business alloc] initWithJson:businessDic];
    }
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

+(void)listLatestByUser:(NSString *)userId
                  limit:(NSNumber *)limit
                   skip:(NSNumber *)skip
                success:(void(^)(NSArray *hairfies))aSuccessHandler
                failure:(void(^)(NSError *error))aFailureHandler
{
    NSDictionary *parameters = @{
        @"filter": @{
            @"where": @{@"userId": userId},
            @"limit": limit,
            @"skip": skip
        }
    };
    
    [[self repository] invokeStaticMethod:@"find"
                               parameters:parameters
                                  success:aSuccessHandler
                                  failure:aFailureHandler];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
}

@end
