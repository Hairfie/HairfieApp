//
//  AppDelegate.h
//  HairfieApp
//
//  Created by Ghislain on 25/07/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <LoopBack/LoopBack.h>
#import "User.h"
#import "Hairfie.h"
#import "KeychainItemWrapper.h"
#import "CredentialStore.h"
#import "Reachability.h"
#import "HairfieUploader.h"
#import <FacebookSDK/FacebookSDK.h>
#import "HairfieNotifications.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>



@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)     CLLocationManager *manager;
@property (nonatomic)     CLLocation *myLocation;
@property (nonatomic) GeoPoint *currentLocation;
@property (nonatomic) User *currentUser;
@property (nonatomic) Hairfie *hairfie;
@property (nonatomic) CredentialStore *credentialStore;
+ ( LBRESTAdapter *) lbAdaptater;
@property (nonatomic) KeychainItemWrapper *keychainItem;
@property (nonatomic) FBSession *fbSession;
@property (nonatomic) Reachability *reachability;
@property (nonatomic) HairfieNotifications *hairfieNotif;
@property (nonatomic) HairfieUploader *hairfieUploader;
@property () BOOL restrictRotation;

-(void)showLoginStoryboard;
-(void)startTrackingLocation:(BOOL)forceLocation;


@end

