//
//  BusinessClaim.h
//  HairfieApp
//
//  Created by Leo Martin on 23/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>
#import "BusinessClaimRepository.h"
#import "GeoPoint.h"
#import "Address.h"
#import "User.h"
#import "Timetable.h"

@interface BusinessClaim : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) GeoPoint *gps;
@property (strong, nonatomic) User *author;
@property (strong, nonatomic) NSMutableArray *phoneNumber;
@property (strong, nonatomic) Timetable *timetable;
@property (strong, nonatomic) Address *address;
@property (strong, nonatomic) NSMutableArray *pictures;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSArray *services;
@property (strong, nonatomic) NSString *kind;
@property (strong, nonatomic) NSString *authorRole;
@property (nonatomic) BOOL men;
@property (nonatomic) BOOL women;
@property (nonatomic) BOOL children;

-(void)claimWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler;
@end
