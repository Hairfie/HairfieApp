//
//  AppDelegate.h
//  HairfieApp
//
//  Created by Ghislain on 25/07/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)     CLLocationManager *manager;
@property (nonatomic)     CLGeocoder *geocoder;
@property (nonatomic)     CLLocation *myLocation;
@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;


-(void)startTrackingLocation:(BOOL)forceLocation;

@end

