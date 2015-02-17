//
//  BusinessMember.h
//  HairfieApp
//
//  Created by Leo Martin on 01/10/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>
#import "Business.h"
#import "Picture.h"
#import "User.h"

@interface BusinessMember : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) Business *business;
@property (nonatomic) BOOL active;
@property (strong, nonatomic) Picture *picture;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSNumber *numHairfies;

-(NSDictionary*)toDictionary;

-(NSString*)displayFullName;

-(NSString *)displayHairfies;

-(id)initWithDictionary:(NSDictionary *)aDictionary;

+(id)fromSetterValue:(id)aValue;

-(NSURL *)pictureUrlWithWidth:(NSNumber *)aWdith
                       height:(NSNumber *)anHeight;

+(void)getById:(NSString *)aBusinessMemberId
   withSuccess:(void (^)(BusinessMember *))aSuccessHandler
       failure:(void (^)(NSError *))aFailureHandler;

@end
