//
//  ThirdStepMapViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ThirdStepMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) IBOutlet MKMapView *businessMapView;

@property (nonatomic) CLLocation *businessLocation;

@end
