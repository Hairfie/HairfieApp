//
//  SalonDetailViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 04/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalonDetailViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic) IBOutlet UIScrollView *imageSliderView;
@property (nonatomic) IBOutlet UIPageControl *pageControl;


@property (nonatomic) IBOutlet UIView *infoView;
@property (nonatomic) IBOutlet UIView *hairfieView;
@property (nonatomic) IBOutlet UIView *hairdresserView;
@property (nonatomic) IBOutlet UIView *salesView;


@property (nonatomic) IBOutlet UIButton *infoBttn;
@property (nonatomic) IBOutlet UIButton *hairfieBttn;
@property (nonatomic) IBOutlet UIButton *hairdresserBttn;
@property (nonatomic) IBOutlet UIButton *salesBttn;

-(IBAction)goBack:(id)sender;
-(IBAction)changePage:(id)sender;
-(IBAction)changeTab:(id)sender;



@end
