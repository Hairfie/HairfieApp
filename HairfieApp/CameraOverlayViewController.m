//
//  CameraOverlayViewController.m
//  HairfieApp
//
//  Created by Ghislain de Juvigny on 12/09/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CameraOverlayViewController.h"
#import "ApplyFiltersViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define GO_TO_LIBRARY_TAG 99
#define FACE_SHAPE_TAG 98


@interface CameraOverlayViewController ()

@end

@implementation CameraOverlayViewController

@synthesize imageTaken;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imagePicker = [[UIImagePickerController alloc]init];
    [_imagePicker setDelegate:self];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        _imagePicker.showsCameraControls = NO;
        _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        _imagePicker.allowsEditing = YES;
        [self initOverlayView];
        [self presentViewController:_imagePicker animated:NO completion:nil];
    } else {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:NO completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initOverlayView
{
    
    UIView *overlayView = [[UIView alloc] init];
    
    overlayView.frame =  _imagePicker.cameraOverlayView.frame;
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    navigationView.backgroundColor = [UIColor blackHairfie];
    
    
    UIImage *goBackImg = [UIImage imageNamed:@"arrow-nav.png"];
    UIButton *goBackButton = [UIButton
                              buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:goBackImg forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(cancelTakePicture) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setFrame:CGRectMake(10, 32, 20, 20)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 30, 136, 23)];
    titleLabel.text = @"Post Hairfie";
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [navigationView addSubview:titleLabel];
    [navigationView addSubview:goBackButton];
    [overlayView addSubview:navigationView];
    
    
    UIImage *takePictureImg = [UIImage imageNamed:@"take-picture-button.png"];
    
    UIButton *takePictureButton = [UIButton
                                   buttonWithType:UIButtonTypeCustom];
    [takePictureButton setImage:takePictureImg forState:UIControlStateNormal];
    [takePictureButton addTarget:self action:@selector(snapPicture) forControlEvents:UIControlEventTouchUpInside];
    [takePictureButton setFrame:CGRectMake(122, 387, 77, 77)];
    
    takePictureButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;

    [self addLastPictureFromLibrary];
    [self addGoToLibraryButton:nil toView:overlayView];
    
    UIImage *switchCameraImg = [UIImage imageNamed:@"switch-camera-button.png"];
    
    UIButton *switchCameraButton = [UIButton
                                    buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:switchCameraImg forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setFrame:CGRectMake(218, 65, 52, 52)];
    [switchCameraButton setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];
    
    UIImage *switchHelpImg = [UIImage imageNamed:@"help-hairfie.png"];
    
    UIButton *switchHelpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchHelpButton setImage:switchHelpImg forState:UIControlStateNormal];
    [switchHelpButton addTarget:self action:@selector(switchHelp) forControlEvents:UIControlEventTouchUpInside];
    [switchHelpButton setFrame:CGRectMake(10, 65, 52, 52)];
    [switchHelpButton setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];
    

    [overlayView addSubview:switchCameraButton];
    [overlayView addSubview:switchHelpButton];
    [overlayView addSubview:takePictureButton];
    [self addFaceShapeToOverlay:overlayView];

    _imagePicker.cameraOverlayView = overlayView;
}

-(void) addFaceShapeToOverlay:(UIView *)cameraOverlayView {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 0, 280, 350)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    [maskLayer setStrokeColor:[[UIColor whiteHairfie] CGColor]];
    [maskLayer setLineWidth:2.0f];
    maskLayer.fillColor = [UIColor clearColor].CGColor;

    UIView *faceShape = [[UIView alloc] initWithFrame:CGRectMake(10, 70, 280, 350)];
    
    [faceShape.layer addSublayer:maskLayer];

    faceShape.tag = FACE_SHAPE_TAG;
    
    [cameraOverlayView insertSubview:faceShape atIndex:0];
}

-(void) removeFaceShapeFromOverlay {
    for (UIView *subView in _imagePicker.cameraOverlayView.subviews) {
        if (subView.tag == FACE_SHAPE_TAG) [subView removeFromSuperview];
    }
}

-(void)switchHelp {
    if([_imagePicker.cameraOverlayView viewWithTag:FACE_SHAPE_TAG] == nil) {
        NSLog(@"view not present");
        [self addFaceShapeToOverlay:_imagePicker.cameraOverlayView];
    } else {
        [[_imagePicker.cameraOverlayView viewWithTag:FACE_SHAPE_TAG] removeFromSuperview];
    }
}


-(void) addLastPictureFromLibrary {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                     if (nil != group) {
                                         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                         
                                         
                                         [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:group.numberOfAssets - 1]
                                                                 options:0
                                                              usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                                  if (nil != result) {
                                                                      ALAssetRepresentation *repr = [result defaultRepresentation];
                                                                      // this is the most recent saved photo
                                                                      UIImage *img = [UIImage imageWithCGImage:[repr fullResolutionImage]];
                                                                      [self addGoToLibraryButton:img toView:_imagePicker.cameraOverlayView];
                                                                      // we only need the first (most recent) photo -- stop the enumeration
                                                                      *stop = YES;
                                                                  }
                                                              }];
                                     }
                                     
                                     *stop = NO;
                                 } failureBlock:^(NSError *error) {
                                     NSLog(@"error: %@", error);
                                 }];
    

}

-(void)addGoToLibraryButton:(UIImage *)img toView:(UIView *)cameraOverlayView {
    UIButton *goToLibrary = [UIButton buttonWithType:UIButtonTypeCustom];
    if(img == nil) {
        [goToLibrary setBackgroundColor:[UIColor whiteHairfie]];
    } else {
        [goToLibrary setImage:img forState:UIControlStateNormal];
    }
    goToLibrary.layer.cornerRadius = 5;
    goToLibrary.layer.masksToBounds = YES;
    goToLibrary.layer.borderWidth = 1;
    goToLibrary.layer.borderColor = [UIColor whiteColor].CGColor;
    [goToLibrary addTarget:self action:@selector(switchCameraSourceType) forControlEvents:UIControlEventTouchUpInside];
    [goToLibrary setFrame:CGRectMake(20, 420, 44, 44)];
    goToLibrary.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    for (UIView *subView in cameraOverlayView.subviews) {
        if (subView.tag == GO_TO_LIBRARY_TAG) [subView removeFromSuperview];
    }
    goToLibrary.tag = GO_TO_LIBRARY_TAG;
    [cameraOverlayView addSubview:goToLibrary];
}

- (void)switchCamera
{
    if (_imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceRear)
    {
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    else
    {
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

-(void) switchCameraSourceType
{
    [_imagePicker dismissViewControllerAnimated:NO completion:nil];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.allowsEditing = YES;
    [self presentViewController:_imagePicker animated:YES completion:nil];
}

-(void)snapPicture
{
    [_imagePicker takePicture];
}

-(void) cancelTakePicture
{
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self SetImageTakenForSegue:info];
    [self performSegueWithIdentifier:@"cameraFilters" sender:self];
    [picker dismissViewControllerAnimated:NO completion:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)SetImageTakenForSegue:(NSDictionary*) info
{
    if([info valueForKey:UIImagePickerControllerEditedImage]) {
        imageTaken = [info valueForKey:UIImagePickerControllerEditedImage];
    } else {
        imageTaken = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"cameraFilters"])
    {
        ApplyFiltersViewController *filters = [segue destinationViewController];
        
        filters.hairfie = imageTaken;
        
    }
}

@end
