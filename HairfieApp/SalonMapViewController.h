//
//  SalonMapViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 11/3/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Business.h"

@interface SalonMapViewController : UIViewController <MKMapViewDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic) IBOutlet UILabel *headerTitle;
@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) Business *business;


@end
