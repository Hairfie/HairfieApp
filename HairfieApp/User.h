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

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSDictionary *picture;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *numHairfies;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *language;

-(id)initWithJson:(NSDictionary *)data;
-(NSString *)name;
-(NSString *)displayName;
-(NSString *)displayHairfies;
-(NSString *)pictureUrlwithWidth:(NSString *)width andHeight:(NSString *)height;
-(NSString *)pictureUrl;
-(NSString *)thumbUrl;

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler;

+(void)getById:(NSString *)anId
     success:(void(^)(User *user))aSuccessHandler
     failure:(void(^)(NSError *error))aFailureHandler;

+(void)listHairfieLikesByUser:(NSString *)userId
                        until:(NSDate *)until
                        limit:(NSNumber *)limit
                         skip:(NSNumber *)skip
                      success:(void(^)(NSArray *hairfieLikes))aSuccessHandler
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
