//
//  AroundMeViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 30/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AroundMeViewController.h"
#import "Annotation.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

@interface AroundMeViewController ()

@end

@implementation AroundMeViewController
{
    NSDictionary *salons;
}
@synthesize manager = _manager, geocoder = _geocoder, placemark = _placemark, mapView = _mapView;


- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    [_manager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
    [self getItems];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)zoomIn:(id)sender {
    MKUserLocation *userLocation = _mapView.userLocation;
    MKCoordinateRegion region =
    MKCoordinateRegionMakeWithDistance (
                                        userLocation.location.coordinate, 20000, 20000);
    [_mapView setRegion:region animated:NO];
    [self addAnnotations];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *crnLoc = [locations lastObject];
    _latitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.latitude];
    _longitude = [NSString stringWithFormat:@"%.8f",crnLoc.coordinate.longitude];
}
-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) addAnnotations {
    NSDictionary *info = [salons valueForKey:@"obj"];
    NSDictionary *coords = [info valueForKey:@"gps"];
    NSArray *longitude = [coords valueForKey:@"lng"];
    NSArray *latitude = [coords valueForKey:@"lat"];
    NSArray *name =[info valueForKey:@"name"];
    for ( int i= 0; i<[longitude count]; i++)
    {
        CLLocationCoordinate2D coord;
        
        coord.longitude = [[NSString stringWithFormat:@"%@",[longitude objectAtIndex:i]] floatValue];
        
        coord.latitude = [[NSString stringWithFormat:@"%@",[latitude objectAtIndex:i]] floatValue];
        
        NSString *titleStr = [name objectAtIndex:i];
        
   
        if (i == 3)
        {
            NSLog(@"%f %f %@", coord.longitude, coord.latitude, titleStr );
        }
        Annotation *annotObj =[[Annotation alloc]initWithCoordinate:coord name:titleStr];
        
        [_mapView addAnnotation:annotObj];
        
       
    }
    
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = 48.8673885;
    location.longitude = 2.3370847;
    region.span = span;
    region.center = location;
    
    [_mapView setRegion:region animated:YES];
}

- (void)getItems
{
    NSString *urlString = [NSString stringWithFormat:@"http://salons.hairfie.com/api/salons/nearby?lat=%@&lng=%@&limit=0.01", @"48.8673885", @"2.3370847"];
    NSURL *urlforrequest = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlforrequest];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        salons = (NSDictionary *)responseObject;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
    [alertView show];
    }];
    [operation start];
}
/*

- (void) getItems
{
    NSString *urlStr = [NSString stringWithFormat:@"http://salons.hairfie.com/api/salons/nearby?lat=%@&lng=%@&limit=0.01", @"48.8673885", @"2.3370847"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
        
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
