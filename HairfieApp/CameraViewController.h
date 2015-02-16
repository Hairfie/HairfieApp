//
//  CameraViewController.h
//  HairfieApp
//
//  Created by Antoine Hérault on 13/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraPreviewView.h"

@protocol CameraViewControllerDelegate;

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) id <CameraViewControllerDelegate> delegate;

@property (nonatomic) IBOutlet CameraPreviewView *preview;
@property (nonatomic) IBOutlet UIButton *takePicture;
@property (nonatomic) IBOutlet UIButton *switchCamera;
@property (nonatomic) IBOutlet UIButton *openGallery;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;
@property (nonatomic, readonly, getter = isSessionRunningAndDeviceAuthorized) BOOL sessionRunningAndDeviceAuthorized;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@protocol CameraViewControllerDelegate

-(void)cameraViewController:(CameraViewController *)vc didTakePicture:(UIImage *)image;

-(void)cameraViewControllerDidCancel:(CameraViewController *)vc;

@end