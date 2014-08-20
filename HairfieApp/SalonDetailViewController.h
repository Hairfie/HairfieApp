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

@interface SalonDetailViewController : UIViewController <UIScrollViewDelegate, RatingViewDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic) IBOutlet UIScrollView *imageSliderView;
@property (nonatomic) IBOutlet UIPageControl *pageControl;


@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic) IBOutlet UIView *hairfieView;
@property (nonatomic) IBOutlet UIView *hairdresserView;
@property (nonatomic) IBOutlet UIView *salesView;
@property (nonatomic) IBOutlet UIView *tabView;
@property (nonatomic) IBOutlet UIView *telephoneBgView;
@property (nonatomic) IBOutlet UIView *pricesView;


@property (nonatomic) IBOutlet UIButton *callBttn;


// Page inside detail Salon

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
@property (nonatomic) IBOutlet UILabel *isOpenLabel;
@property (nonatomic) IBOutlet UILabel *isOpenLabelDetail;
@property (nonatomic) IBOutlet UIImageView *isOpenImage;
@property (nonatomic) IBOutlet UIImageView *isOpenImageDetail;


@property (nonatomic) NSString *haidresserLat;
@property (nonatomic) NSString *haidresserLng;


@property (nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic) IBOutlet UITableView *similarTableView;

@property (nonatomic) IBOutlet UIButton *addReviewBttn;
@property (nonatomic) IBOutlet UIButton *moreReviewBttn;

@property (nonatomic) NSDictionary *dataSalon;

@property (nonatomic) IBOutlet MKMapView *previewMap;


// View Info



// Constraints modified for salon info = null

@property (nonatomic) IBOutlet NSLayoutConstraint *telephoneLabelWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *addReviewButtonYpos;
@property (nonatomic) IBOutlet NSLayoutConstraint *addReviewButtonXpos;
@property (nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;

-(IBAction)goBack:(id)sender;
-(IBAction)changePage:(id)sender;
-(IBAction)changeTab:(id)sender;



@end
