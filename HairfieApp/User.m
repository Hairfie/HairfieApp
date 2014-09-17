//
//  User.m
//  HairfieApp
//
//  Created by Leo Martin on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "User.h"
#import "CredentialStore.h"
#import "AppDelegate.h"
#import "MenuViewController.h"

@implementation User

@synthesize id, userToken, email, firstName, lastName, picture, numHairfies;

-(NSString *)name {
    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
}

-(NSString *)displayName {
    return [NSString stringWithFormat:@"%@ %@.", firstName, [lastName substringToIndex:1]];
}

-(NSString *)displayHairfies {
    if ([self.numHairfies integerValue] < 2) {
        return [NSString stringWithFormat:@"%@ hairfie", self.numHairfies];
    } else {
        return [NSString stringWithFormat:@"%@ hairfies", self.numHairfies];
    }
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

-(NSString *)thumbUrl {
    return [self pictureUrlwithWidth:@"100" andHeight:@"100"];
}

-(id)initWithJson:(NSDictionary *)data
{
    return (User *)[[User repository] modelWithDictionary:data];
}

+(void)getById:(NSString *)anId
     success:(void (^)(User *user))aSuccessHandler
     failure:(void (^)(NSError *error))aFailureHandler
{
    [[User repository] findById:anId
                        success:^(LBModel *result) {
                            aSuccessHandler(result);
                        }
                        failure:aFailureHandler];
}

+(void)listHairfiesLikedByUser:(NSString *)userId
                         limit:(NSNumber *)limit
                          skip:(NSNumber *)skip
                       success:(void(^)(NSArray *hairfies))aSuccessHandler
                       failure:(void(^)(NSError *error))aFailureHandler
{
    NSDictionary *parameters = @{
                                 @"userId": userId,
                                 @"filter": @{
                                         @"limit": limit,
                                         @"skip": skip,
                                         @"order": @"createdAt DESC"
                                         }
                                 };
    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/liked-hairfies"
                                                                                 verb:@"GET"]
                                        forMethod:@"users.getLikedHairfies"];
    
    [[User repository] invokeStaticMethod:@"getLikedHairfies"
                               parameters:parameters
                                  success:^(NSArray *results) {
                                      NSMutableArray *hairfies = [[NSMutableArray alloc] init];
                                      for (NSDictionary *result in results) {
                                          [hairfies addObject:[[Hairfie repository] modelWithDictionary:result]];
                                      }
                                      aSuccessHandler([[NSArray alloc] initWithArray: hairfies]);
                                      
                                  }
                                  failure:aFailureHandler];
}

+(void)isHairfie:(NSString *)hairfieId
     likedByUser:(NSString *)userId
         success:(void(^)(BOOL isLiked))aSuccessHandler
         failure:(void(^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/liked-hairfies/:hairfieId"
                                                                                 verb:@"HEAD"]
                                        forMethod:@"users.isLikedHairfie"];
    
    [[User repository] invokeStaticMethod:@"isLikedHairfie"
                               parameters:@{@"userId": userId, @"hairfieId": hairfieId}
                                  success:^(id value) {
                                      aSuccessHandler(YES);
                                  }
                                  failure:^(NSError *error) {
                                      NSString *httpString = [[error userInfo] objectForKey:@"NSLocalizedRecoverySuggestion"];
                                      NSDictionary *httpDic = [NSJSONSerialization
                                                               JSONObjectWithData: [httpString dataUsingEncoding:NSUTF8StringEncoding]
                                                               options: NSJSONReadingMutableContainers
                                                               error: &error];
                                      int statusCode = [[[httpDic objectForKey:@"error"] objectForKey:@"statusCode"] integerValue];
                                      
                                      if (statusCode == 404) {
                                          // 404 means the like doesn't exist
                                          return aSuccessHandler(NO);
                                      }
                                      
                                      aFailureHandler(error);
                                  }];
}

+(void)likeHairfie:(NSString *)hairfieId
            asUser:(NSString *)userId
           success:(void (^)())aSuccessHandler
           failure:(void (^)(NSError *))aFailureHandler
{    
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/liked-hairfies/:hairfieId"
                                                                                 verb:@"PUT"]
                                        forMethod:@"users.likeHairfie"];

    [[User repository] invokeStaticMethod:@"likeHairfie"
                               parameters:@{@"userId": userId, @"hairfieId": hairfieId}
                                  success:^(id value) {
                                      aSuccessHandler();
                                  }
                                  failure:aFailureHandler];
}

+(void)unlikeHairfie:(NSString *)hairfieId
            asUser:(NSString *)userId
           success:(void (^)())aSuccessHandler
           failure:(void (^)(NSError *))aFailureHandler
{
    [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/users/:userId/liked-hairfies/:hairfieId"
                                                                                 verb:@"DELETE"]
                                        forMethod:@"users.unlikeHairfie"];

    [[User repository] invokeStaticMethod:@"unlikeHairfie"
                               parameters:@{@"userId": userId, @"hairfieId": hairfieId}
                                  success:^(id value) {
                                      aSuccessHandler();
                                  }
                                  failure:aFailureHandler];
}

+(LBModelRepository *)repository
{
    return [[AppDelegate lbAdaptater] repositoryWithClass:[UserRepository class]];
}

@end