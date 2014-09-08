//
//  HairfieRequest.m
//  HairfieApp
//
//  Created by Leo Martin on 08/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfieRequest.h"
#import "HairfieRepository.h"
#import "AppDelegate.h"
#import "Hairfie.h"

@implementation HairfieRequest{
    AppDelegate *delegate;
    NSArray *hairfies;
}

- (id)init {
    self = [super init];
    if (self) {
        delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void) getHairfies:(LBModelAllSuccessBlock)success
             failure:(SLFailureBlock)failure {
    
      HairfieRepository *hairfieRepository = (HairfieRepository*)[[AppDelegate lbAdaptater] repositoryWithClass:[HairfieRepository class]];
    
//    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
//        NSLog(@"Error on load %@", error.description);
//    };
//   void (^loadSuccessBlock)(NSArray *) = ^(NSArray *model){
//        hairfies = model;
//        NSLog(@"Hairfie : %@", hairfies);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"hairfie" object:self];
//    };
    
    [hairfieRepository allWithSuccess:success failure:failure];
}




@end
