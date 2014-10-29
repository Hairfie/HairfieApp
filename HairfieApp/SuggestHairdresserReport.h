//
//  SuggestHairdresserReport.h
//  HairfieApp
//
//  Created by Leo Martin on 10/29/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <LoopBack/LoopBack.h>
#import "Business.h"

@interface SuggestHairdresserReport : LBModel

@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;

-(id)initWithBusiness:(Business *)aBusiness;

-(void)saveWithSuccess:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler;

@end
