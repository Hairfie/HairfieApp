//
//  CameraViewController.m
//  HairfieApp
//
//  Created by Antoine Hérault on 13/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "CameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * SessionRunningAndDeviceAuthorizedContext = &SessionRunningAndDeviceAuthorizedContext;

@interface CameraViewController ()

@end

@implementation CameraViewController
{
    dispatch_queue_t sessionQueue;
    AVCaptureDeviceInput *videoDeviceInput;
    id runtimeErrorHandlingObserver;
}

+(NSSet *)keyPathsForValuesAffectingSessionRunningAndDeviceAuthorized
{
    return [NSSet setWithObjects:@"session.running", @"deviceAuthorized", nil];
}

-(BOOL)isSessionRunningAndDeviceAuthorized
{
    return self.session.isRunning && self.isDeviceAuthorized;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPreset1280x720; // enough, as we save 640x640 pictures
    
    sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    
    self.preview.session = self.session;
    
    [self checkDeviceAuthorizationStatus];
    
    dispatch_async(sessionQueue, ^{
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [[self class] videoDevicePreferringPosition:AVCaptureDevicePositionBack];
        videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if (error) {
            NSLog(@"Failed to get capture device input: %@", error);
        }
        
        if ([self.session canAddInput:videoDeviceInput]) {
            [self.session addInput:videoDeviceInput];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[(AVCaptureVideoPreviewLayer *)self.preview.layer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
            });
        }
        
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ([self.session canAddOutput:self.stillImageOutput]) {
            self.stillImageOutput.outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
            [self.session addOutput:self.stillImageOutput];
        }
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.delegate = self;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    dispatch_async(sessionQueue, ^{
        [self addObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:SessionRunningAndDeviceAuthorizedContext];
        [self addObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:CapturingStillImageContext];

        __weak CameraViewController *weakSelf = self;
        runtimeErrorHandlingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureSessionRuntimeErrorNotification object:self.session queue:nil usingBlock:^(NSNotification *note) {
            CameraViewController *strongSelf = weakSelf;
            [strongSelf.session startRunning];
        }];
        
        [self.session startRunning];
    });
    
    [self loadLastImageFromLibrary];
}

-(void)viewDidDisappear:(BOOL)animated
{
    dispatch_async(sessionQueue, ^{
        [self.session stopRunning];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDeviceInput.device];
        [[NSNotificationCenter defaultCenter] removeObserver:runtimeErrorHandlingObserver];
        
        [self removeObserver:self forKeyPath:@"sessionRunningAndDeviceAuthorized" context:SessionRunningAndDeviceAuthorizedContext];
        [self removeObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" context:CapturingStillImageContext];
    });
}

-(void)setPictureTaken:(UIImage *)image
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.delegate cameraViewController:self didTakePicture:[self scaleImage:image]];
}

-(void)cancel
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.delegate cameraViewControllerDidCancel:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image;
    if([info valueForKey:UIImagePickerControllerEditedImage]) {
        image = [info valueForKey:UIImagePickerControllerEditedImage];
    } else {
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];

    [self setPictureTaken:image];
}

- (IBAction)takePicture:(id)sender
{
    dispatch_async(sessionQueue, ^{
        [[self class] disableFlashForDevice:videoDeviceInput.device];
        
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            if (imageDataSampleBuffer) {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                [self setPictureTaken:[[UIImage alloc] initWithData:imageData]];
            }
        }];
    });
}

-(IBAction)openGallery:(id)sender
{
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

-(IBAction)goBack:(id)sender
{
    [self cancel];
}

-(IBAction)switchCamera:(id)sender
{
    self.takePicture.enabled = NO;
    self.switchCamera.enabled = NO;
    
    dispatch_async(sessionQueue, ^{
        AVCaptureDevice *currentVideoDevice = videoDeviceInput.device;
        AVCaptureDevicePosition currentPosition = currentVideoDevice.position;
        AVCaptureDevicePosition targetPosition = AVCaptureDevicePositionUnspecified;
        
        switch (currentPosition) {
            case AVCaptureDevicePositionUnspecified:
                targetPosition = AVCaptureDevicePositionBack;
                break;
                
            case AVCaptureDevicePositionBack:
                targetPosition = AVCaptureDevicePositionFront;
                break;
                
            case AVCaptureDevicePositionFront:
                targetPosition = AVCaptureDevicePositionBack;
                break;
        }
        
        AVCaptureDevice *selectedDevice = [[self class] videoDevicePreferringPosition:targetPosition];
        AVCaptureDeviceInput *selectedDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:selectedDevice error:nil];
        
        [self.session beginConfiguration];
        [self.session removeInput:videoDeviceInput];
        if ([[self session] canAddInput:videoDeviceInput]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
            
            [[self class] disableFlashForDevice:selectedDevice];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:selectedDevice];
            
            [self.session addInput:selectedDeviceInput];
            videoDeviceInput = selectedDeviceInput;
        } else {
            [self.session addInput:videoDeviceInput];
        }
        [self.session commitConfiguration];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.takePicture.enabled = YES;
            self.switchCamera.enabled = YES;
        });
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == CapturingStillImageContext) {
        BOOL isCapturing = [change[NSKeyValueChangeNewKey] boolValue];
        if (isCapturing) {
            [self runStillImageCaptureAnimation];
        }
    } else if (context == SessionRunningAndDeviceAuthorizedContext) {
        BOOL isRunning = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.takePicture.enabled = isRunning;
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)subjectAreaDidChange:(NSNotification *)notification
{
    CGPoint devicePoint = CGPointMake(.5, .5);
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange
{
    dispatch_async(sessionQueue, ^{
        AVCaptureDevice *device = videoDeviceInput.device;
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode]) {
                [device setFocusMode:focusMode];
                [device setFocusPointOfInterest:point];
            }
            if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode]) {
                [device setExposureMode:exposureMode];
                [device setExposurePointOfInterest:point];
            }
            [device setSubjectAreaChangeMonitoringEnabled:monitorSubjectAreaChange];
            [device unlockForConfiguration];
        } else {
            NSLog(@"Failed to focus: %@", error);
        }
    });
}

+(void)disableFlashForDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:AVCaptureFlashModeOff]) {
        NSError *error = nil;
        if ([device lockForConfiguration:&error]) {
            [device setFlashMode:AVCaptureFlashModeOff];
            [device unlockForConfiguration];
        } else {
            NSLog(@"Failed to set flash mode: %@", error);
        }
    }
}

+(AVCaptureDevice *)videoDevicePreferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

-(void)runStillImageCaptureAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.preview.layer.opacity = 0.0;
        [UIView animateWithDuration:.25 animations:^{
            self.preview.layer.opacity = 1.0;
        }];
    });
}

-(UIImage *)scaleImage:(UIImage *)image
{
    // crop image to make it square
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    CGFloat size = MIN(imageWidth, imageHeight);
    CGFloat x = (imageWidth - size) / 2;
    CGFloat y = (imageHeight - size) / 2;
    CGRect cropRect = CGRectMake(x, y, size, size);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:0.0f orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    // scale it to 640x640
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(640, 640), NO, 0.0);
    [croppedImage drawInRect:CGRectMake(0, 0, 640, 640)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted) {
            self.deviceAuthorized = YES;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.deviceAuthorized = NO;
                
                [[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning",@"Claim", nil)
                                           message:NSLocalizedStringFromTable(@"authorized access to camera", @"Post_Hairfie", nil)
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles: nil] show];
            });
        }
    }];
}

-(void)loadLastImageFromLibrary
{
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
                                                                          UIImage *image = [UIImage imageWithCGImage:[repr fullResolutionImage]];
                                                                          
                                                                          [self.openGallery setImage:image forState:UIControlStateNormal];

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

@end
