//
//  ApplyFiltersViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 09/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Filters.h"
#import "HairfiePost.h"
#import "User.h"

@interface ApplyFiltersViewController : UIViewController <UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic) HairfiePost *hairfiePost;

@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UIImageView *firstImageView;
@property (nonatomic) IBOutlet UIImageView *secondImageView;

@property (nonatomic) IBOutlet UIView *filtersView;


@property (nonatomic) IBOutlet UIButton *nextBttn;
@property (nonatomic) IBOutlet UIButton *editBttn;
@property (nonatomic) IBOutlet UIButton *secondImgBttn;


@property (nonatomic) UIImage *userPicture;
@property (nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic) IBOutlet UIButton *originalBttn;
@property (nonatomic) IBOutlet UIButton *sepiaBttn;
@property (nonatomic) IBOutlet UIButton *curveBttn;
@property (nonatomic) IBOutlet UIButton *transferBttn;
@property (nonatomic) IBOutlet UIButton *instantBttn;
@property (nonatomic) IBOutlet UIButton *processBttn;
@property (nonatomic) IBOutlet UIButton *photoEffectNoirBttn;
@property (nonatomic) IBOutlet UIButton *vignetteBttn;
@property (nonatomic) IBOutlet UIButton *vintageBttn;

@property (nonatomic) BOOL isHairfie;
@property (nonatomic) BOOL isSecondHairfie;

@property (nonatomic) NSMutableArray *hairfiePics;

// change profile pic
@property (nonatomic) User *user;
@property (nonatomic) BOOL isProfile;


@end
