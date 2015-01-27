//
//  HomeViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 28/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvanceSearch.h"
#import "GAITrackedViewController.h"
#import "AKPickerView.h"


//@class PopUpViewController;

@interface HomeViewController : GAITrackedViewController <UINavigationControllerDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, AKPickerViewDelegate, AKPickerViewDataSource, UIPageViewControllerDataSource>

@property (nonatomic) IBOutlet UILabel *AroundMeLabel;
@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UIScrollView *scrollTest;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) IBOutlet UIView *topBarView;
@property (nonatomic) IBOutlet UIImageView *hairfieLogo;
@property (nonatomic) PopUpViewController *popViewController;
@property (nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic) IBOutlet UIButton *takeHairfieBttn;
@property (nonatomic) IBOutlet UILabel *filterSearchBttnTitle;

@property (nonatomic) AKPickerView *pickerView;
@property (nonatomic) IBOutlet UIView *pickerContainerView;

@property (strong, nonatomic) UIPageViewController *pageViewController;


@property (nonatomic) BOOL isNotLogged;
@property (nonatomic) BOOL didClaim;

//-(void) userNotLogged;

@end
