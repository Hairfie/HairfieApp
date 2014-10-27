//
//  FinalStepViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessClaim.h"
#import "Business.h"

@interface FinalStepViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIButton *phoneBttn;

@property (nonatomic) IBOutlet UIButton *addressBttn;

@property (nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic) IBOutlet UILabel *phoneLabel;

@property (nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic) IBOutlet UIScrollView *imageSliderView;
@property (nonatomic) IBOutlet UIPageControl *pageControl;


@property (nonatomic) IBOutlet UIButton* validateBttn;
@property (nonatomic) IBOutlet NSLayoutConstraint *validateBttnWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *validateBttnXpos;

@property (nonatomic) IBOutlet UIView *pageControlView;

@property (nonatomic) BusinessClaim *claim;
@property (nonatomic) IBOutlet UIButton *navButton;
@property (nonatomic) IBOutlet UIButton *menuButton;

// TAB VIEW

@property (nonatomic) IBOutlet UIButton* infoBttn;
@property (nonatomic) IBOutlet UIButton* hairfieBttn;
@property (nonatomic) IBOutlet UIButton* hairdresserBttn;
@property (nonatomic) IBOutlet UIButton* priceAndSaleBttn;
@property (nonatomic) IBOutlet UIButton* descriptionBttn;
@property (nonatomic) IBOutlet UIButton* timetableBttn;
@property (nonatomic) IBOutlet UIView* containerView;
@property (nonatomic) IBOutlet UIView* infoView;
@property (nonatomic) IBOutlet UIView* hairfieView;
@property (nonatomic) IBOutlet UIView* hairdresserView;
@property (nonatomic) IBOutlet UIView* priceAndSaleView;


@property (nonatomic) IBOutlet UIView* topBarView;

// HAIRFIE TAB

@property (nonatomic) IBOutlet UIButton* addHairfiesBttn;
@property (nonatomic) IBOutlet UILabel* addHairfiesLbl;


// HAIRDRESSER TAB

@property (nonatomic) IBOutlet UITableView* hairdresserTableView;
@property BOOL isEditingHairdresser;

// PRICES/SALES TAB

@property (nonatomic) IBOutlet UITableView* serviceTableView;
@property BOOL isEditingService;

// FROM SEGUE

@property (nonatomic, strong) Business *businessToManage;

@end
