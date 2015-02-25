//
//  HairfiePostCameraViewController.m
//  HairfieApp
//
//  Created by Antoine Hérault on 20/02/2015.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "HairfiePostCameraViewController.h"
#import "HairfiePostDetailsViewController.h"

@interface HairfiePostCameraViewController ()

@end

@implementation HairfiePostCameraViewController
{
    ImageSetPicker *picker;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (nil == picker) {
        self.myAppDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        picker = [ImageSetPicker setup:self];
    }
}

-(void)imageSetPickerDidCancel:(ImageSetPicker *)imageSetPicker
{    
    [ImageSetPicker remove:picker];
    picker = nil;
    [self.myAppDelegate.hairfieUploader removeHairfiePost];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imageSetPicker:(ImageSetPicker *)imageSetPicker didReturnWithImages:(NSArray *)images
{
    [ImageSetPicker remove:picker];
    picker = nil;
    
    
    [self.myAppDelegate.hairfieUploader setupHairfieUploader];
    [self.myAppDelegate.hairfieUploader.hairfiePost setImages:images];
    [self.myAppDelegate.hairfieUploader uploadHairfieImages];
    
    [self performSegueWithIdentifier:@"hairfiePostDetails" sender:self];
}

-(NSInteger)imageSetPickerMinimumImageCount:(ImageSetPicker *)imageSetPicker
{
    return 1;
}

-(NSInteger)imageSetPickerMaximumImageCount:(ImageSetPicker *)imageSetPicker
{
    return 2;
}

@end
