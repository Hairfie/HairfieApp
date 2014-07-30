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

@interface AroundMeViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) NSString *longitude;
@property (nonatomic) NSString *latitude;

@property (nonatomic) IBOutlet MKMapView *mapView;




@property (nonatomic)  CLLocationManager *manager;
@property (nonatomic)     CLGeocoder *geocoder;
@property (nonatomic)     CLPlacemark *placemark;

-(IBAction)goBack:(id)sender;

@end
