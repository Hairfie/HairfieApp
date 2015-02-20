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
#import "CameraViewController.h"

#define GO_TO_LIBRARY_TAG 99
#define FACE_SHAPE_TAG 98


@interface CameraOverlayViewController ()

@end

@implementation CameraOverlayViewController
{
    CameraViewController *cameraViewController;
}

@synthesize imageTaken;

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!_hairfiePost){
        _hairfiePost = [[HairfiePost alloc] init];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [ARAnalytics pageView:@"AR - Post Hairfie step #1 - Camera Overlay"];
    
    cameraViewController = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
    cameraViewController.delegate = self;
    [self addChildViewController:cameraViewController];
    cameraViewController.view.frame = self.view.frame;
    [self.view addSubview:cameraViewController.view];
    [cameraViewController didMoveToParentViewController:self];
}

-(void)cameraViewController:(CameraViewController *)vc didTakePicture:(UIImage *)image
{
    imageTaken = image;
    
    if (self.isSecondHairfie == YES)
    {
        ApplyFiltersViewController *filtersVc = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        
        filtersVc.isSecondHairfie = YES;
        filtersVc.isHairfie = NO;
        [filtersVc.hairfiePost setPictureWithImage:imageTaken andContainer:@"hairfies"];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.isHairfie == YES || self.isProfile == YES)
        [self performSegueWithIdentifier:@"cameraFilters" sender:self];
    else if (self.isHairfie == NO)
        [self performSegueWithIdentifier:@"validatePicture" sender:self];
}

-(void)cameraViewControllerDidCancel:(CameraViewController *)vc
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"cameraFilters"])
    {
        ApplyFiltersViewController *filters = [segue destinationViewController];
        [_hairfiePost setPictureWithImage:imageTaken andContainer:@"hairfies"];
        filters.hairfiePost = _hairfiePost;
        filters.isHairfie = YES;
       
        if(self.isSecondHairfie == YES) {
            filters.isSecondHairfie = YES;
            filters.isHairfie = NO;
        }
        if (self.isProfile == YES) {
            filters.isProfile = YES;
            filters.user = self.user;
        }
        
    }
    if ([segue.identifier isEqualToString:@"validatePicture"])
    {
        ApplyFiltersViewController *filters = [segue destinationViewController];
        
        [filters setUserPicture:imageTaken];
        filters.isHairfie = NO;

    }
    
}

@end
