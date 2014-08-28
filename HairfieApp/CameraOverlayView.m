//
//  CameraOverlayView.m
//  HairfieApp
//
//  Created by Leo Martin on 12/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "CameraOverlayView.h"

#define CAMERAFRONT @"UIImagePickerControllerCameraDeviceFront"
#define CAMERABACK 

@interface CameraOverlayView ()

@end

@implementation CameraOverlayView


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    navigationView.backgroundColor = [UIColor colorWithRed:40/255.0f green:49/255.0f blue:57/255.0f alpha:1];
    
    
    UIImage *goBackImg = [UIImage imageNamed:@"arrow-nav.png"];
    UIButton *goBackButton = [UIButton
                            buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:goBackImg forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setFrame:CGRectMake(10, 32, 20, 20)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 30, 136, 23)];
    titleLabel.text = @"Post Hairfie";
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [navigationView addSubview:titleLabel];
    [navigationView addSubview:goBackButton];
    [self.view addSubview:navigationView];
    
    
    UIImage *takePictureImg = [UIImage imageNamed:@"take-picture-button.png"];
    
    UIButton *takePictureButton = [UIButton
                              buttonWithType:UIButtonTypeCustom];
    [takePictureButton setImage:takePictureImg forState:UIControlStateNormal];
    [takePictureButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [takePictureButton setFrame:CGRectMake(122, 401, 77, 77)];
    
    takePictureButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    UIImage *switchCameraImg = [UIImage imageNamed:@"switch-camera-button.png"];
    
    UIButton *switchCameraButton = [UIButton
                                   buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:switchCameraImg forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCamera) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setFrame:CGRectMake(268, 75, 32, 32)];
    
    [self.view addSubview:switchCameraButton];
    [self.view addSubview:takePictureButton];
    
    // Do any additional setup after loading the view.
}


-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)switchCamera
{
    
   // NSLog(@"Switch Camera");
    
     if (self.cameraDevice == UIImagePickerControllerCameraDeviceRear)
     {
         self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
     }
     else
     {
         self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
     }
    
}





-(void)takePicture
{
    UIImagePickerController *test = [[UIImagePickerController alloc] init];
    [test takePicture];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
