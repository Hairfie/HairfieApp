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
#import "Business.h"

@interface SalonDetailViewController : UIViewController <UIScrollViewDelegate, RatingViewDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>


@property (nonatomic) IBOutlet UIView *headerContainerView;

@property (nonatomic) IBOutlet UIView *mainView;
@property (nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic) IBOutlet UIView *tabView;

@property (nonatomic) IBOutlet UIView *telephoneBgView;
@property (nonatomic) IBOutlet UIView *pricesView;


@property (nonatomic) IBOutlet UIButton *callBttn;


// Page inside detail Salon

@property (nonatomic) IBOutlet UIButton *infoBttn;
@property (nonatomic) IBOutlet UIButton *hairfieBttn;
@property (nonatomic) IBOutlet UIButton *hairdresserBttn;
@property (nonatomic) IBOutlet UIButton *priceAndSaleBttn;

@property (nonatomic) IBOutlet UIView *infoView;
@property (nonatomic) IBOutlet UIView *hairfieView;
@property (nonatomic) IBOutlet UIView *hairdresserView;
@property (nonatomic) IBOutlet UIView *priceAndSaleView;
@property (nonatomic) IBOutlet UIView *containerView;

/////////

@property (weak, nonatomic) IBOutlet RatingView *salonRating;
@property (weak, nonatomic) IBOutlet UIView *containerReview;
@property (weak, nonatomic) IBOutlet RatingView *reviewRating;


@property (nonatomic) IBOutlet UILabel *salonAvailability;

@property (nonatomic) IBOutlet UILabel *address;
@property (nonatomic) IBOutlet UILabel *city;
@property (nonatomic) IBOutlet UILabel *telephone;
@property (nonatomic) IBOutlet UILabel *isOpenLabel;
@property (nonatomic) IBOutlet UILabel *isOpenLabelDetail;
@property (nonatomic) IBOutlet UIImageView *isOpenImage;
@property (nonatomic) IBOutlet UIImageView *isOpenImageDetail;
@property (nonatomic) IBOutlet UIImageView *isPhoneAvailable;
@property (nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic) IBOutlet UITableView *similarTableView;
@property (nonatomic) IBOutlet UITableView *detailTableView;

@property (nonatomic) IBOutlet UIView *detailedContainerView;

@property (nonatomic) IBOutlet UIButton *addReviewBttn;
@property (nonatomic) IBOutlet UIButton *moreReviewBttn;

@property (strong, nonatomic) Business *business;
@property (strong, nonatomic) NSArray *similarBusinesses;

// View Hairfie

@property (nonatomic) IBOutlet UICollectionView *hairfieCollection;
@property (nonatomic) IBOutlet NSLayoutConstraint *hairfieCollectionHeight;
@property (nonatomic) BOOL isAddingHairfie;

// View Hairdressers

@property (nonatomic) IBOutlet UITableView *hairdresserTableView;
@property (nonatomic) IBOutlet NSLayoutConstraint *hairdresserTableViewHeight;

// View Sales

@property (nonatomic) IBOutlet UITableView *pricesTableView;
@property (nonatomic) IBOutlet NSLayoutConstraint *pricesTableViewHeight;

// Constraints modified for salon info = null

@property (nonatomic) IBOutlet NSLayoutConstraint *telephoneLabelWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *addReviewButtonYpos;
@property (nonatomic) IBOutlet NSLayoutConstraint *addReviewButtonXpos;
@property (nonatomic) IBOutlet NSLayoutConstraint *moreReviewButtonYpos;
@property (nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;


@property (nonatomic) BOOL didClaim;
@property (nonatomic) IBOutlet UIButton *goBackBttn;
@property (nonatomic) IBOutlet UIButton *menuBttn;



-(IBAction)goBack:(id)sender;
-(IBAction)changeTab:(id)sender;



@end
