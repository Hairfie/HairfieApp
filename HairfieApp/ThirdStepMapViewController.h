//
//  ThirdStepMapViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BusinessClaim.h"

@interface ThirdStepMapViewController : UIViewController <MKMapViewDelegate, UINavigationControllerDelegate>

@property (nonatomic) IBOutlet MKMapView *businessMapView;
@property (nonatomic) IBOutlet UIButton *nextBttn;
@property (nonatomic) CLLocation *businessLocation;
@property (nonatomic) BusinessClaim *claim;

@end
