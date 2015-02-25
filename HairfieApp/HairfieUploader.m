//
//  HairfieUploader.m
//  HairfieApp
//
//  Created by Leo Martin on 2/24/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "AppDelegate.h"
#import "HairfieUploader.h"
#import "HairfieNotifications.h"
#import <Social/Social.h>

typedef void(^myCompletion)(BOOL);

@implementation HairfieUploader
{
    BOOL postInProgress;
    UIApplication* app;
    BOOL didRetry;
    BOOL isReadyToPost;

    UIAlertView *hairfieAlert;
    UIAlertView *uploadAlert;
    AppDelegate *appDelegate;
    HairfieNotifications *hairfieNotif;
}

#define OVERLAY_TAG 99

-(id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

-(void)setupHairfieUploader {
    
    hairfieNotif = [HairfieNotifications new];
    if (nil == self.hairfiePost.business) {
        self.hairfiePost = [[HairfiePost alloc] init];
    }
    isReadyToPost = NO;
    self.hairfiePost.pictures = nil;
    app = [UIApplication sharedApplication];
    appDelegate = (AppDelegate*)app.delegate;
    postInProgress = NO;
    didRetry = NO;
  
}



-(void)uploadHairfieImages {
    
    app.networkActivityIndicatorVisible = YES;
    [self.hairfiePost uploadPictureWithSuccess:^{
        app.networkActivityIndicatorVisible = NO;
       
        if (isReadyToPost == YES)
        {
            [self postHairfie];
        }
    } failure:^(NSError *error) {
        [self showPostHairfieFailedAlertView];
        
        NSLog(@"Error HAIRFIE: %@", error.description);
    }];
}

-(void)postHairfie
{
    
    [hairfieNotif showNotificationWithMessage:NSLocalizedStringFromTable(@"Upload in progress", @"Post_Hairfie", nil)];
   
    app.networkActivityIndicatorVisible = YES;
    NSLog(@"Post Hairfie");
   
    
    isReadyToPost = YES;
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
        [hairfieNotif dismissNotification];
        postInProgress = NO;
        [self showPostHairfieFailedAlertView];
    };
    void (^loadSuccessBlock)(Hairfie *) = ^(Hairfie *hairfie){
        NSLog(@"Hairfie Posté");
        [hairfieNotif dismissNotificationWithCompletion:^{
            [hairfieNotif showNotificationWithMessage:NSLocalizedStringFromTable(@"Hairfie Post Successful", @"Post_Hairfie", nil) ForDuration:2.5];
        }];
        postInProgress = NO;
        self.hairfiePost = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
        app.networkActivityIndicatorVisible = NO;
    };
    
    if (isReadyToPost == YES && [self.hairfiePost pictureIsUploaded] && postInProgress != YES) {
        [self.hairfiePost saveWithSuccess:loadSuccessBlock failure:loadErrorBlock];
        postInProgress = YES;
   }
}


-(void)showPostHairfieFailedAlertView
{
    hairfieAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedStringFromTable(@"There was an error uploading your hairfie, Try Again !", @"Post_Hairfie", nil)  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"Retry",nil];
    [hairfieAlert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (![self.hairfiePost pictureIsUploaded]) {
        [self uploadHairfieImages];
    } else {
        [self postHairfie];
    }
}




@end
