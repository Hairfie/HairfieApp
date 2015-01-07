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

@interface HomeViewController : GAITrackedViewController <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegateFlowLayout, AKPickerViewDelegate, AKPickerViewDataSource>

@property (nonatomic) IBOutlet UILabel *AroundMeLabel;
@property (nonatomic) IBOutlet UICollectionView *hairfieCollection;
@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UIScrollView *scrollTest;
@property (nonatomic) IBOutlet UICollectionReusableView *headerView;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) IBOutlet UIView *topBarView;

@property (nonatomic) PopUpViewController *popViewController;
@property (nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic) IBOutlet UIButton *takeHairfieBttn;

@property (nonatomic) AKPickerView *pickerView;
@property (nonatomic) IBOutlet UIView *pickerContainerView;




@property (nonatomic) BOOL isNotLogged;
@property (nonatomic) BOOL didClaim;

//-(void) userNotLogged;

@end
