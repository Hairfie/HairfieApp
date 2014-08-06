//
//  AroundMeViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 30/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AroundMeViewController.h"
#import "MyAnnotation.h"
#import "CustomPinView.h"
#import "AppDelegate.h"

#import "SalonTableViewCell.h"
#import "SalonDetailViewController.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

@interface AroundMeViewController ()

@end

@implementation AroundMeViewController
{
    NSArray *salons;
    CLLocation *myLocation;
    NSInteger rowSelected;
}
@synthesize manager = _manager, geocoder = _geocoder, mapView = _mapView, hairdresserTableView = _hairdresserTableView, delegate = _delegate, myLocation = _myLocation;


- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];

    _hairdresserTableView.delegate = self;
    _hairdresserTableView.dataSource = self;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
   
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) updatedLocation:(NSNotification*)notif {
    _myLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
    
    [self initMapWithSalons];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [_delegate startTrackingLocation:YES];
  //  userLocation = _mapView.userLocation;
     [self initMapWithSalons];
}

 
-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Init a map on user location
// Get Salons from webservice
-(void) initMapWithSalons {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (_myLocation.coordinate, 1000, 1000);
    [_mapView setRegion:region animated:NO];
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self getSalons];
}

-(void) addSalonsToMap {
    
    for ( int i= 0; i<[salons count]; i++) {
        NSDictionary *salon = [salons objectAtIndex:i];
        [self addSalonToMap:salon];
    }
    [_hairdresserTableView reloadData];
}

// Add a salon to the map
- (void) addSalonToMap: (NSDictionary *) salon {
    NSDictionary *info = [salon valueForKey:@"obj"];
    NSDictionary *coords = [info valueForKey:@"gps"];
    NSString *titleStr = [info valueForKey:@"name"];

    CLLocationCoordinate2D coord;
    coord.longitude = [[NSString stringWithFormat:@"%@",[coords valueForKey:@"lng"]] floatValue];
    coord.latitude = [[NSString stringWithFormat:@"%@",[coords valueForKey:@"lat"]] floatValue];
    
    MyAnnotation *annotObj =[[MyAnnotation alloc]init];
    
    annotObj.title = titleStr;
    annotObj.coordinate = coord;
    
    [_mapView addAnnotation:annotObj];
     [_hairdresserTableView reloadData];
}

// Get Salons from webservices then add them to the map
- (void)getSalons
{
    NSString *urlString = [NSString stringWithFormat:@"%@/salons/nearby?lat=%f&lng=%f&max=1&limit=10", BASE_URL, _myLocation.coordinate.latitude, _myLocation.coordinate.longitude];
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
    return [salons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"salonCell";
    SalonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SalonTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *salon = [[salons objectAtIndex:indexPath.row] objectForKey:@"obj"];
    [cell customInit:salon];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   // SalonDetailViewController *salonDetail = [[SalonDetailViewController alloc] init];
    
  //  salonDetail.dataSalon = [salons objectAtIndex:indexPath.row];
  //  NSLog(@"%@", [salons objectAtIndex:indexPath.row]);
    rowSelected = indexPath.row;
   [self performSegueWithIdentifier:@"salonDetail" sender:self];
    //[self prepareForSegue:@"detailSalon" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"salonDetail"])
    {
        SalonDetailViewController *salonDetail = [segue destinationViewController];
        [salonDetail setDataSalon:[salons objectAtIndex:rowSelected]];
    }
    
}


// MKAnnotation delegate methods

// Set up the MKAnnotation View

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {

    static NSString *myIdentifier =@"MyAnnotation";

    if([annotation isKindOfClass:[MyAnnotation class]])
    {
        MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:myIdentifier];
        if(!annotationView)
        {
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
            annotationView.image = [UIImage imageNamed:@"custom-map-pin.png"];
            annotationView.contentMode = UIViewContentModeScaleAspectFit;
            annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height / 2);
            annotationView.canShowCallout = YES;
        }
        return annotationView;
    }
    return nil;
}






// Method for showing custom view on annotation

/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)annotationView {
    
    CustomPinView *calloutView = [[CustomPinView alloc] initWithFrame:CGRectMake(0.0, 0.0, 70, 30.0)];
    
    calloutView.myTitle.text = annotationView.annotation.title;
    
    
    calloutView.center = CGPointMake(CGRectGetWidth(annotationView.bounds) / 2.0, 0.0);
    [annotationView addSubview:calloutView];
   
    
}
 
// Methods for when the user deselect the annotation

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for (UIView *subview in view.subviews) {
        if (![subview isKindOfClass:[CustomPinView class]]) {
            continue;
        }
        
        [subview removeFromSuperview];
    }
}
*/


/*

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
