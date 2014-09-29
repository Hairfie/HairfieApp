//
//  BusinessErrorReport.h
//  HairfieApp
//
//  Created by Antoine Hérault on 29/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>
#import "Business.h"
#import "User.h"

@interface BusinessErrorReport : LBModel

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) User *author;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

-(id)initWithBusiness:(Business *)aBusiness
                 body:(NSString *)aBody;

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler;

@end
