//
//  SalonDetailViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 04/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "MyButton.h"

@interface SalonDetailViewController : UIViewController <UIScrollViewDelegate, RatingViewDelegate>

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



-(IBAction)goBack:(id)sender;
-(IBAction)changePage:(id)sender;
-(IBAction)changeTab:(id)sender;



@end
