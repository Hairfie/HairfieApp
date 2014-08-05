//
//  SalonDetailViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 04/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

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

@property (weak, nonatomic) IBOutlet RatingView *ratingView;

@property (nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic) IBOutlet UITableView *similarTableView;

@property (nonatomic) IBOutlet UIButton *addReviewBttn;
@property (nonatomic) IBOutlet UIButton *moreReviewBttn;

-(IBAction)goBack:(id)sender;
-(IBAction)changePage:(id)sender;
-(IBAction)changeTab:(id)sender;



@end
