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
#import "Picture.h"


@interface User : LBModel

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) Picture  *picture;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSNumber *numHairfies;
@property (strong, nonatomic) NSNumber *numBusinessReviews;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSArray *managedBusinesses;

-(id)initWithDictionary:(NSDictionary *)data;
-(NSString *)name;
-(NSString *)displayName;
-(NSString *)displayHairfies;
-(NSURL *)pictureUrlwithWidth:(NSNumber *)width andHeight:(NSNumber *)height;
-(NSURL *)pictureUrl;

+(NSString *)EVENT_CHANGED;

-(BOOL)hasClaimedBusinesses;

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

-(void)getManagedBusinessesByUserSuccess:(void (^)())aSuccessHandler
                                 failure:(void (^)(NSError *))aFailureHandler;

+(id)fromSetterValue:(id)aValue;
-(void)refresh;

@end
