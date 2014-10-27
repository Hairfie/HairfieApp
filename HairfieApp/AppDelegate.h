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
#import <FacebookSDK/FacebookSDK.h>


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

-(void)showLoginStoryboard;
-(void)startTrackingLocation:(BOOL)forceLocation;

@end

