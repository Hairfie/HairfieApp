//
//  FBUtils.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 24/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUtils : NSObject

+(void)getPermissions:(NSArray *)permissionsNeeded
              success:(void(^)())aSuccessHandler
              failure:(void(^)(NSError *error))aFailureHandler;

@end
