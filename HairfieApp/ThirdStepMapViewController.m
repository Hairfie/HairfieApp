//
//  ThirdStepMapViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ThirdStepMapViewController.h"
#import "BusinessAnnotation.h"

@interface ThirdStepMapViewController ()

@end

@implementation ThirdStepMapViewController

#define METERS_PER_MILE 1609.344

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self centerMap];
    _nextBttn.layer.cornerRadius = 5;
    _nextBttn.layer.masksToBounds = YES;
    // Do any additional setup after loading the view.
}

-(IBAction)goBack:(id)sender
{
    NSLog(@"test");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"drag to %f,%f", _businessMapView.centerCoordinate.longitude, _businessMapView.centerCoordinate.latitude);
}

-(void)centerMap
{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_businessLocation.coordinate, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    
    [_businessMapView setRegion:viewRegion animated:YES];
    _businessMapView.camera.altitude *= 1;
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
