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
@property (nonatomic) NSString *userId;
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

@end
