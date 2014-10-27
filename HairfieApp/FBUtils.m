//
//  FBUtils.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 24/10/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FBUtils.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FBUtils

+(void)getPermissions:(NSArray *)permissionsNeeded success:(void (^)())aSuccessHandler failure:(void (^)(NSError *))aFailureHandler {
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  NSMutableDictionary *currentPermissions= [[NSMutableDictionary alloc] init];
                                  for (NSDictionary *permission in (NSArray *)[result data]){
                                      [currentPermissions setObject:[permission objectForKey:@"status"] forKey:[permission objectForKey:@"permission"]];
                                  }
                                  
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession requestNewPublishPermissions:requestPermissions
                                                                            defaultAudience:FBSessionDefaultAudienceFriends
                                                                          completionHandler:^(FBSession *session, NSError *error) {
                                                                              if (!error) {
                                                                                  NSLog(@"Share is OK !");
                                                                                  aSuccessHandler();
                                                                              } else {
                                                                                  NSLog(@"%@", error.description);
                                                                                  aFailureHandler(error);
                                                                              }
                                                                          }];
                                  } else {
                                      aSuccessHandler();
                                  }
                                  
                              } else {
                                  NSLog(@"%@", error.description);
                                  aFailureHandler(error);
                              }
                          }];
}
@end
