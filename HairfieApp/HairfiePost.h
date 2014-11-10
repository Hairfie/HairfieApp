//
//  HairfiePost.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 15/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>
#import "User.h"
#import "Business.h"
#import "Hairdresser.h"
#import "HairfieRepository.h"
#import "Picture.h"
#import "Money.h"
#import "HairfieShare.h"
#import "Tag.h"

@interface HairfiePost : LBModel

@property (strong, nonatomic) Picture *picture;
@property (strong, nonatomic) Hairdresser *hairdresser;
@property (strong, nonatomic) NSString *description;
@property (nonatomic)         BOOL shareOnFB;
@property (nonatomic)         BOOL shareOnTwitter;
@property (strong, nonatomic) Money *price;
@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) NSArray *tags;
@property (nonatomic)         BOOL selfMade;
@property (nonatomic)         NSString *customerEmail;


-(id)initWithDictionary:(NSDictionary *)data;
-(id)initWithBusiness:(Business *)aBusiness;

-(void)setPictureWithImage:(UIImage *)image andContainer:(NSString *)container;

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler;

-(void)uploadPictureWithSuccess:(void(^)())aSuccessHandler
                        failure:(void(^)(NSError *error))aFailureHandler;

-(BOOL)pictureIsUploaded;

+(HairfieRepository *)repository;

@end
