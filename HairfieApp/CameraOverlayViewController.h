//
//  CameraOverlayViewController.h
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 12/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraOverlayViewController : UIViewController

@property (nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) IBOutlet UIButton *takePictureButton;
@property (nonatomic) IBOutlet UIImage *imageTaken;

@end
