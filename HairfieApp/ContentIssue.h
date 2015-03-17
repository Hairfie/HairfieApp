//
//  ContentIssue.h
//  HairfieApp
//
//  Created by Antoine Hérault on 17/03/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>

@interface ContentIssue : LBModel

+(void)createWithTitle:(NSString *)theTitle
               andBody:(NSString *)theBody
               success:(void(^)())aSuccessHandler
               failure:(void(^)(NSError *error))aFailureHandler;

@end
