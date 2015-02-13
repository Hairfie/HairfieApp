//
//  CameraPreviewView.m
//  HairfieApp
//
//  Created by Antoine Hérault on 13/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "CameraPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation CameraPreviewView

+(Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

-(AVCaptureSession *)session
{
    return [(AVCaptureVideoPreviewLayer *)self.layer session];
}

-(void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    layer.session = session;
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

@end
