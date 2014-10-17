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

@implementation CameraOverlayViewController {
    float diff;
}

@synthesize imageTaken;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!_hairfiePost){
        _hairfiePost = [[HairfiePost alloc] init];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [ARAnalytics pageView:@"AR - Post Hairfie step #1 - Camera Overlay"];
    [self setupImagePicker];
}

-(void) setupImagePicker {
    if(!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        [_imagePicker setDelegate:self];
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            _imagePicker.showsCameraControls = NO;
            _imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            _imagePicker.allowsEditing = YES;
            
            diff = 0; //(self.view.frame.size.height - self.view.frame.size.width / 3 * 4)/2;
            
            [self initOverlayView];
            NSLog(@"diff %f", diff);
            
        } else {
            _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _imagePicker.allowsEditing = YES;
        }
    }
    if(![self.presentedViewController isEqual:_imagePicker]) {
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
    navigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.78];
    
    
    UIImage *goBackImg = [UIImage imageNamed:@"arrow-nav.png"];
    UIButton *goBackButton = [UIButton
                              buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:goBackImg forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(cancelTakePicture) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setFrame:CGRectMake(0, 22, 60, 40)];
    [goBackButton setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,30)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 30, 136, 23)];
    titleLabel.text = NSLocalizedStringFromTable(@"Take Hairfie", @"Post_Hairfie", nil);
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor titleGrey];
    [navigationView addSubview:titleLabel];
    [navigationView addSubview:goBackButton];
    
    UIView *bottomNavigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 380, 320, self.view.frame.size.height - 380)];
    bottomNavigationView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.78];
    
    [overlayView addSubview:navigationView];
    [overlayView addSubview:bottomNavigationView];
    
    
    UIImage *takePictureImg = [UIImage imageNamed:@"take-picture-button.png"];
    
    UIButton *takePictureButton = [UIButton
                                   buttonWithType:UIButtonTypeCustom];
    [takePictureButton setImage:takePictureImg forState:UIControlStateNormal];
    [takePictureButton addTarget:self action:@selector(snapPicture) forControlEvents:UIControlEventTouchUpInside];
    [takePictureButton setFrame:CGRectMake(122, 380 + bottomNavigationView.frame.size.height/2 - 38 + diff, 77, 77)];
    
    takePictureButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;

    [self addLastPictureFromLibrary];
    [self addGoToLibraryButton:nil toView:overlayView];
    
    UIImage *switchCameraImg = [UIImage imageNamed:@"switch-camera-button.png"];
    
    UIButton *switchCameraButton = [UIButton
                                    buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:switchCameraImg forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setFrame:CGRectMake(248, 65, 52, 52)];
    [switchCameraButton setImageEdgeInsets:UIEdgeInsetsMake(10,10,10,10)];

    [overlayView addSubview:switchCameraButton];
    [overlayView addSubview:takePictureButton];
    //[self addFaceShapeToOverlay:overlayView];

    _imagePicker.cameraOverlayView = overlayView;
}




-(void) addLastPictureFromLibrary {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                     if (nil != group) {
                                         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                         
                                         if(group.numberOfAssets > 0) {
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
    float topPos = 380 + (self.view.frame.size.height - 380)/2 - 44/2 + diff;
    [goToLibrary setFrame:CGRectMake(20, topPos, 44, 44)];
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
    
    if( _imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera
       && _imagePicker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        imageTaken = [UIImage imageWithCGImage:imageTaken.CGImage scale:imageTaken.scale orientation:UIImageOrientationLeftMirrored];
    }
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"cameraFilters"])
    {
        ApplyFiltersViewController *filters = [segue destinationViewController];

        [_hairfiePost setPictureWithImage:imageTaken andContainer:@"hairfies"];
        filters.hairfiePost = _hairfiePost;
        
    }
}

@end
