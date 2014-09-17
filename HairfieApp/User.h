//
//  User.h
//  HairfieApp
//
//  Created by Leo Martin on 28/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>
#import "UserRepository.h"


@interface User : LBModel

@property (nonatomic) NSString *userToken;
@property (nonatomic) NSString *id;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *gender;
@property (nonatomic) NSDictionary *picture;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *numHairfies;

-(id)initWithJson:(NSDictionary *)data;
-(NSString *)name;
-(NSString *)displayName;
-(NSString *)displayHairfies;
-(NSString *)pictureUrlwithWidth:(NSString *)width andHeight:(NSString *)height;
-(NSString *)pictureUrl;
-(NSString *)thumbUrl;

+(void)getById:(NSString *)anId
     success:(void(^)(User *user))aSuccessHandler
     failure:(void(^)(NSError *error))aFailureHandler;

+(void)listHairfiesLikedByUser:(NSString *)userId
                         limit:(NSNumber *)limit
                          skip:(NSNumber *)skip
                       success:(void(^)(NSArray *hairfies))aSuccessHandler
                       failure:(void(^)(NSError *error))aFailureHandler;

+(void)isHairfie:(NSString *)hairfieId
     likedByUser:(NSString *)userId
         success:(void(^)(BOOL isLiked))aSuccessHandler
         failure:(void(^)(NSError *))aFailureHandler;

+(void)likeHairfie:(NSString *)hairfieId
            asUser:(NSString *)userId
           success:(void (^)())aSuccessHandler
           failure:(void (^)(NSError *))aFailureHandler;

+(void)unlikeHairfie:(NSString *)hairfieId
            asUser:(NSString *)userId
           success:(void (^)())aSuccessHandler
           failure:(void (^)(NSError *))aFailureHandler;

@end
