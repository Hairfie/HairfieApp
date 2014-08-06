//
//  SalonDetailViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 04/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import <MapKit/MapKit.h>

@interface SalonDetailViewController : UIViewController <UIScrollViewDelegate, RatingViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UIScrollView *imageSliderView;
@property (nonatomic) IBOutlet UIPageControl *pageControl;


@property (nonatomic) IBOutlet UIView *infoView;
@property (nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic) IBOutlet UIView *hairfieView;
@property (nonatomic) IBOutlet UIView *hairdresserView;
@property (nonatomic) IBOutlet UIView *salesView;
@property (nonatomic) IBOutlet UIView *tabView;


@property (nonatomic) IBOutlet UIButton *infoBttn;
@property (nonatomic) IBOutlet UIButton *hairfieBttn;
@property (nonatomic) IBOutlet UIButton *hairdresserBttn;
@property (nonatomic) IBOutlet UIButton *salesBttn;

@property (weak, nonatomic) IBOutlet RatingView *salonRating;
@property (weak, nonatomic) IBOutlet RatingView *reviewRating;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (nonatomic) IBOutlet UILabel *salonAvailability;

@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *address;
@property (nonatomic) IBOutlet UILabel *city;
@property (nonatomic) IBOutlet UILabel *manPrice;
@property (nonatomic) IBOutlet UILabel *womanPrice;
@property (nonatomic) IBOutlet UILabel *telephone;
@property (nonatomic) IBOutlet UILabel *nbReviews;



@property (nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic) IBOutlet UITableView *similarTableView;

@property (nonatomic) IBOutlet UIButton *addReviewBttn;
@property (nonatomic) IBOutlet UIButton *moreReviewBttn;

@property (nonatomic) NSDictionary *dataSalon;

@property (nonatomic) IBOutlet MKMapView *previewMap;

-(IBAction)goBack:(id)sender;
-(IBAction)changePage:(id)sender;
-(IBAction)changeTab:(id)sender;



@end
