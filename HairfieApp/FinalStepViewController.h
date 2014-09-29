//
//  FinalStepViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessClaim.h"

@interface FinalStepViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIButton *phoneBttn;

@property (nonatomic) IBOutlet UIButton *addressBttn;

@property (nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic) IBOutlet UIScrollView *imageSliderView;
@property (nonatomic) IBOutlet UIPageControl *pageControl;


@property (nonatomic) IBOutlet UIButton* validateBttn;

@property (nonatomic) IBOutlet UIView *pageControlView;

@property (nonatomic) BusinessClaim *claim;


// TAB VIEW

@property (nonatomic) IBOutlet UIButton* infoBttn;
@property (nonatomic) IBOutlet UIButton* hairfieBttn;
@property (nonatomic) IBOutlet UIButton* hairdresserBttn;
@property (nonatomic) IBOutlet UIButton* priceAndSaleBttn;

@property (nonatomic) IBOutlet UIView* containerView;
@property (nonatomic) IBOutlet UIView* infoView;
@property (nonatomic) IBOutlet UIView* hairfieView;
@property (nonatomic) IBOutlet UIView* hairdresserView;
@property (nonatomic) IBOutlet UIView* priceAndSaleView;

// HAIRFIE TAB

@property (nonatomic) IBOutlet UIButton* addHairfiesBttn;

@end
