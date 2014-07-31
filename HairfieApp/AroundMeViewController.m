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
    NSArray *salons;
    MKUserLocation *userLocation;
}
@synthesize manager = _manager, geocoder = _geocoder, placemark = _placemark, mapView = _mapView, hairdresserTableView = _hairdresserTableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    _manager.desiredAccuracy = kCLLocationAccuracyBest;
    //[_manager startUpdatingLocation];
    [_manager startMonitoringSignificantLocationChanges];
    _hairdresserTableView.delegate = self;
    _hairdresserTableView.dataSource = self;
    _mapView.showsUserLocation = YES;
    [self initMapWithSalons];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)zoomIn:(id)sender {
    [self initMapWithSalons];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation* location = [locations lastObject];
    _latitude = [NSString stringWithFormat:@"%.8f",location.coordinate.latitude];
    _longitude = [NSString stringWithFormat:@"%.8f",location.coordinate.longitude];
    
    userLocation = _mapView.userLocation;
    
    [self initMapWithSalons];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Init a map on user location
// Get Salons from webservice
-(void) initMapWithSalons {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 1000, 1000);
    [_mapView setRegion:region animated:NO];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self getSalons];
}

-(void) addSalonsToMap {
    
    for ( int i= 0; i<[salons count]; i++) {
        NSDictionary *salon = [salons objectAtIndex:i];
        [self addSalonToMap:salon];
    }
}

// Add a salon to the map
- (void) addSalonToMap: (NSDictionary *) salon {
    NSDictionary *info = [salon valueForKey:@"obj"];
    NSDictionary *coords = [info valueForKey:@"gps"];
    NSString *titleStr = [info valueForKey:@"name"];

    CLLocationCoordinate2D coord;
    coord.longitude = [[NSString stringWithFormat:@"%@",[coords valueForKey:@"lng"]] floatValue];
    coord.latitude = [[NSString stringWithFormat:@"%@",[coords valueForKey:@"lat"]] floatValue];
    
    Annotation *annotObj =[[Annotation alloc]initWithCoordinate:coord name:titleStr];
    
    [_mapView addAnnotation:annotObj];
}

// Get Salons from webservices then add them to the map
- (void)getSalons
{
    NSLog(@"user latitude %+.6f, user longitude %+.6f\n",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    NSString *urlString = [NSString stringWithFormat:@"http://salons.hairfie.com/api/salons/nearby?lat=%f&lng=%f&limit=0.01", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude];
    NSLog(@"URL: %@", urlString);
    NSURL *urlforrequest = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlforrequest];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        salons = (NSArray *)responseObject;
        [self addSalonsToMap];
        
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



// TableView Delegate Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Results";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault   reuseIdentifier:CellIdentifier];
    }
    return cell;
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
