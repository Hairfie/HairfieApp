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
#import "OLEContainerScrollView.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Resize.h"

@interface AroundMeViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate,SDWebImageManagerDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    NSString *test;
}

@property (nonatomic) NSString *longitude;
@property (nonatomic) NSString *latitude;
@property (nonatomic) AppDelegate *delegate;


@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) IBOutlet UITableView *hairdresserTableView;
@property (nonatomic) IBOutlet OLEContainerScrollView *scrollView;

@property (nonatomic) IBOutlet UIView *headerView;
@property (nonatomic) IBOutlet UIView *searchHeaderView;

// Search Active

@property (nonatomic) IBOutlet UITextView *searchField;
@property (nonatomic) IBOutlet UIButton *cancelBttn;
@property (nonatomic) IBOutlet UIButton *searchBttn;
@property (nonatomic) IBOutlet UITextField *searchByName;
@property (nonatomic) IBOutlet UITextField *searchByLocation;
@property (nonatomic) IBOutlet UIButton *searchAroundMe;
@property (nonatomic) IBOutlet UIImageView *searchAroundMeImage;
@property (nonatomic) BOOL isSearching;

////

@property (nonatomic)  CLLocationManager *manager;
@property (nonatomic)  CLGeocoder *geocoder;
@property (nonatomic)  CLLocation *myLocation;


-(IBAction)goBack:(id)sender;

@end
