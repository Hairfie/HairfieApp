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

#import "SearchFilterViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Resize.h"
#import "AdvanceSearch.h"
#import "SearchFilterViewController.h"
#import "BusinessSearch.h"



@interface AroundMeViewController : UIViewController <MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate,SDWebImageManagerDelegate, UITextViewDelegate, UITextFieldDelegate,SearchFilterDelegate>
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
@property (nonatomic, strong) IBOutlet UILabel *searchDesc;
@property (nonatomic) IBOutlet AdvanceSearch *searchView;

// Search Active

@property (nonatomic) IBOutlet UITextField *searchField;

@property (nonatomic) BOOL isSearching;
@property (nonatomic) BOOL isRefreshing;


// Search In Progress

@property (nonatomic) IBOutlet UILabel *searchInProgress;

@property (strong, nonatomic) BusinessSearch *businessSearch;

-(IBAction)goBack:(id)sender;

@end
