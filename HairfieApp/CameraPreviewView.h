//
//  CameraPreviewView.h
//  HairfieApp
//
//  Created by Antoine Hérault on 13/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
