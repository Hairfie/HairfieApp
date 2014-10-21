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

//@class PopUpViewController;

@interface HomeViewController : GAITrackedViewController <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) IBOutlet UILabel *AroundMeLabel;
@property (nonatomic) IBOutlet UICollectionView *hairfieCollection;
@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet UIScrollView *scrollTest;
@property (nonatomic) IBOutlet UICollectionReusableView *headerView;
@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) IBOutlet UITextField *searchField;
@property (nonatomic) IBOutlet UIView *advancedSearchView;
@property (nonatomic) IBOutlet UIView *topBarView;
@property (nonatomic) IBOutlet AdvanceSearch *searchView;
@property (nonatomic) IBOutlet UIButton *takePictureButton;

@property (nonatomic) PopUpViewController *popViewController;
@property (nonatomic) IBOutlet UIButton *menuButton;

@property (nonatomic) BOOL isNotLogged;
@property (nonatomic) BOOL didClaim;

//-(void) userNotLogged;

@end
