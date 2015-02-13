//
//  CameraOverlayViewController.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 12/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "HairfiePost.h"
#import "CameraViewController.h"

@interface CameraOverlayViewController : UIViewController <CameraViewControllerDelegate, UINavigationControllerDelegate> {
    UINavigationController *navController;
}

@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) HairfiePost *hairfiePost;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) IBOutlet UIButton *takePictureButton;
@property (nonatomic) IBOutlet UIImage *imageTaken;

@property (nonatomic) BOOL isHairfie;
@property (nonatomic) BOOL isSecondHairfie;

// change profile pic
@property (nonatomic) BOOL isProfile;
@property (nonatomic) User *user;

@end
