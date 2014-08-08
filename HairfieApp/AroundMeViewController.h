//
//  AroundMeViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 30/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface AroundMeViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSString *test;
}

@property (nonatomic) NSString *longitude;
@property (nonatomic) NSString *latitude;
@property (nonatomic) AppDelegate *delegate;


@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UITableView *hairdresserTableView;

@property (nonatomic)  CLLocationManager *manager;
@property (nonatomic)  CLGeocoder *geocoder;
@property (nonatomic)  CLLocation *myLocation;

@property (nonatomic) IBOutlet UIScrollView *globalScroll;

@property (nonatomic) IBOutlet UIView *gestureView;

-(IBAction)goBack:(id)sender;

@end
