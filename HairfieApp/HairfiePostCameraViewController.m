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
        picker = [ImageSetPicker setup:self];
    }
}

-(void)imageSetPickerDidCancel:(ImageSetPicker *)imageSetPicker
{    
    [ImageSetPicker remove:picker];
    picker = nil;

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)imageSetPicker:(ImageSetPicker *)imageSetPicker didReturnWithImages:(NSArray *)images
{
    [ImageSetPicker remove:picker];
    picker = nil;
    
    if (nil == self.hairfiePost) {
        self.hairfiePost = [[HairfiePost alloc] init];
    }
    
    [self.hairfiePost setImages:images];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"hairfiePostDetails"]) {
        HairfiePostDetailsViewController *vc = segue.destinationViewController;
        vc.hairfiePost = self.hairfiePost;
    }
}

@end
