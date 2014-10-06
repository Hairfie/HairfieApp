//
//  ThirdStepMapViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ThirdStepMapViewController.h"
#import "BusinessAnnotation.h"
#import "FinalStepViewController.h"

@interface ThirdStepMapViewController ()

@end

@implementation ThirdStepMapViewController
{
    CLLocation *newLocation;
}

#define METERS_PER_MILE 1609.344

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self centerMap];
    _nextBttn.layer.cornerRadius = 5;
    _nextBttn.layer.masksToBounds = YES;
    
    
    
   
    _mapHeight.constant = self.view.frame.size.height - 64;
    _pinYPos.constant = self.view.center.y - 64;
    NSLog(@"_containerView height %f for map height %f", _pinYPos.constant, _mapHeight.constant);
    
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
    
    newLocation = [[CLLocation alloc] initWithLatitude:_businessMapView.centerCoordinate.latitude longitude: _businessMapView.centerCoordinate.longitude];
}


-(IBAction)claimOtherInfos:(id)sender
{
    
    GeoPoint *gps = [[GeoPoint alloc] initWithLocation:newLocation];
    _claim.gps = gps;
  
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
       // NSLog(@"results %@", results);
        _claim.id = [results objectForKey:@"id"];
        [self performSegueWithIdentifier:@"claimOtherInfos" sender:self];
    };
    
    [_claim claimWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"claimOtherInfos"])
    {
        FinalStepViewController *finalStep = [segue destinationViewController];
        finalStep.claim = [[BusinessClaim alloc] init];
        finalStep.claim = _claim;
    }
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
