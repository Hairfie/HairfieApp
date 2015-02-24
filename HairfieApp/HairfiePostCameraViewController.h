//
//  HairfiePostCameraViewController.h
//  HairfieApp
//
//  Created by Antoine Hérault on 20/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HairfiePost.h"
#import "ImageSetPicker.h"

@interface HairfiePostCameraViewController : UIViewController<ImageSetPickerDelegate>

@property (nonatomic, strong) AppDelegate *myAppDelegate;
@property (nonatomic, strong) HairfiePost* hairfiePost;

@end
