//
//  CameraOverlayViewController.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 12/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HairfiePost.h"

@interface CameraOverlayViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UINavigationController *navController;
}

@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) HairfiePost *hairfiePost;

@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) IBOutlet UIButton *takePictureButton;
@property (nonatomic) IBOutlet UIImage *imageTaken;

@property (nonatomic) BOOL isHairfie;

@end
