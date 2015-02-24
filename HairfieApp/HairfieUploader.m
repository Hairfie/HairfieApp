//
//  HairfieUploader.m
//  HairfieApp
//
//  Created by Leo Martin on 2/24/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "HairfieUploader.h"
#import "HairfieNotifications.h"
#import <Social/Social.h>

@implementation HairfieUploader
{
    BOOL uploadInProgress;
    UIApplication* app;
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
    
    self.hairfiePost = [[HairfiePost alloc] init];
    app = [UIApplication sharedApplication];
    uploadInProgress = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUploadStatus:) name:@"firstPicUploaded" object:nil];

}

-(void)changeUploadStatus:(NSNotification*)notification
{
    uploadInProgress = NO;
    if (self.hairfiePost.pictures.count == 1) {
        app.networkActivityIndicatorVisible = NO;
    }
    NSLog(@"First Picture Uploaded");
    Picture *pic = self.hairfiePost.pictures[0];
    NSLog(@"hairfie post %@", pic.url.absoluteString);
}

-(void)uploadHairfieImages {
    
    app.networkActivityIndicatorVisible = YES;
    uploadInProgress = YES;
    [self.hairfiePost uploadPictureWithSuccess:^{
        NSLog(@"Everything Uploaded !");
        app.networkActivityIndicatorVisible = NO;
        uploadInProgress = NO;
    } failure:^(NSError *error) {
        uploadInProgress = NO;
        NSLog(@"Error HAIRFIE: %@", error.description);
    }];
}

-(void)postHairfie
{
    
    app.networkActivityIndicatorVisible = YES;
    NSLog(@"Post Hairfie");
    while (uploadInProgress) {
        NSLog(@"---------- Upload in progress ----------");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    if(![self.hairfiePost pictureIsUploaded]) {
        [self showUploadFailedAlertView];
        return;
    }
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
        [self showUploadFailedAlertView];
        
    };
    void (^loadSuccessBlock)(Hairfie *) = ^(Hairfie *hairfie){
        NSLog(@"Hairfie Posté");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"currentUser" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hairfiePostSuccess" object:self];
        app.networkActivityIndicatorVisible = YES;
          };
    [self.hairfiePost saveWithSuccess:loadSuccessBlock failure:loadErrorBlock];
    
}

-(void)showUploadFailedAlertView
{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedStringFromTable(@"There was an error uploading your hairfie, Try Again !", @"Post_Hairfie", nil)  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self uploadHairfieImages];
}





@end
