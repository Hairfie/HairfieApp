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
#import "SimilarTableViewCell.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

#import <SDWebImage/UIImageView+WebCache.h>


#import "LoginViewController.h"

@interface AroundMeViewController ()

@end

@implementation AroundMeViewController
{
    NSArray *businesses;
    CLLocation *myLocation;
    NSInteger rowSelected;
    UITapGestureRecognizer *tap;
    SDWebImageManager *SDmanager;
    NSString *gpsString;
    UIRefreshControl *refreshControl;
    UIGestureRecognizer *dismiss;
}
@synthesize manager = _manager, geocoder = _geocoder, mapView = _mapView, hairdresserTableView = _hairdresserTableView, delegate = _delegate, myLocation = _myLocation;


- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];
     dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    _isSearching = YES;
    _isRefreshing = NO;
     _hairdresserTableView.hidden = YES;
    [_searchView initView];
    
    if (_searchInProgressFromSegue == nil)
    {
        [_searchView.searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
        _searchView.searchByLocation.text = NSLocalizedStringFromTable(@"Around Me", @"Around_Me", nil);
    }
    else
    {
        _searchView.searchByLocation.text = _queryLocationInProgressFromSegue;
        _searchView.searchByName.text = _queryNameInProgressFromSegue;
    }
    
    _searchView.hidden = YES;
    _hairdresserTableView.delegate = self;
    _hairdresserTableView.dataSource = self;
    _hairdresserTableView.backgroundColor = [UIColor clearColor];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _hairdresserTableView.tableHeaderView = _headerView;
    [_hairdresserTableView setSeparatorInset:UIEdgeInsetsZero];
      SDmanager = [SDWebImageManager sharedManager];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateBusinesses)
             forControlEvents:UIControlEventValueChanged];
    [_hairdresserTableView addSubview:refreshControl];
}


-(void) hideKeyboard
{
    [_searchView.searchByLocation resignFirstResponder];
    [_searchView.searchByName resignFirstResponder];
    _searchView.hidden = YES;
    [self.view removeGestureRecognizer:dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_delegate startTrackingLocation:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willSearch:) name:@"searchQuery" object:nil];
    [ARAnalytics pageView:@"AR - Around me"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchQuery" object:nil];
}


-(void)willSearch:(NSNotification*)notification
{
    
    [_mapView removeAnnotations:_mapView.annotations];
    _searchInProgress.text = _searchView.searchRequest;
    _isSearching = YES;
    if (![_searchView.searchByName.text isEqualToString:@""] && [_searchView.searchByLocation.text isEqualToString:NSLocalizedStringFromTable(@"Around Me", @"Around_Me", nil)])
    {
        if ([_searchView.searchByName.text isEqualToString:@""])
            _searchDesc.text = NSLocalizedStringFromTable(@"HAIRDRESSER AROUND YOU", @"Around_Me", nil);
        else
            _searchDesc.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ AROUND YOU", @"Around_Me", nil), [_searchView.searchByName.text uppercaseString]];
    }
    else
    {
        _searchDesc.text = _searchView.searchRequest;
        [self initMapWithBusinesses:_searchView.locationSearch];
        [_hairdresserTableView setContentOffset:CGPointMake(0, 136)];
    }
}

-(void)updateBusinesses {
    _isSearching = YES;
    _isRefreshing = YES;
    [self getBusinesses:gpsString];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    _searchView.hidden = NO;
    if ([_searchView.searchByLocation.text isEqualToString:NSLocalizedStringFromTable(@"Around Me", @"Around_Me", nil)])
        [_searchView.searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
    [_searchView.searchByName performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
    [self.view addGestureRecognizer:dismiss];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) updatedLocation:(NSNotification*)notif {
    
    if (_gpsStringFromSegue != nil)
    {
        _searchDesc.text = _searchInProgressFromSegue;
        [self initMapWithBusinesses:_locationFromSegue];
    }
    else
    {
        _myLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
        if (_queryNameInProgressFromSegue != nil) {
            _searchView.searchByName.text = _queryNameInProgressFromSegue;
        }
        
        if (_searchInProgressFromSegue != nil)
            _searchDesc.text = _searchInProgressFromSegue;
        [self initMapWithBusinesses:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Init a map on user location
// Get Businesses from webservice

-(void) initMapWithBusinesses:(CLLocation *)customLocation {

    MKCoordinateRegion region;
    if (customLocation == nil) {
        region = MKCoordinateRegionMakeWithDistance (_myLocation.coordinate, 1000, 1000);
        [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        gpsString = [NSString stringWithFormat:@"%f,%f", _myLocation.coordinate.longitude, _myLocation.coordinate.latitude];
        
    } else {
        region = MKCoordinateRegionMakeWithDistance (customLocation.coordinate, 1000, 1000);
        
        gpsString = [NSString stringWithFormat:@"%f,%f", customLocation.coordinate.longitude, customLocation.coordinate.latitude];
    }
    
    if (_gpsStringFromSegue != nil)
    {
        [self getBusinesses:_gpsStringFromSegue];
        
    }
    else
    {
        [self getBusinesses:gpsString];
    }
    //[_mapView setRegion:region animated:NO];
}



-(void) addBusinessesToMap {
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (Business *business in businesses) {
        [annotations addObject:[self annotationForBusiness:business]];
    }
    [_mapView addAnnotations:annotations];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in _mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [_mapView setVisibleMapRect:zoomRect animated:NO];
    _mapView.camera.altitude *= 1.4;
}

// Add a Business to the map

- (MyAnnotation *) annotationForBusiness: (Business *) business
{
    MyAnnotation *annotObj =[[MyAnnotation alloc] init];
    annotObj.title = business.name;
    annotObj.coordinate = [[business.gps location] coordinate];
    
    return annotObj;
}

// Get Salons from webservices then add them to the map

- (void)getBusinesses:(NSString*)address
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setFrame:CGRectMake(150, self.view.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height)];
    spinner.hidesWhenStopped = YES;


    //Error Block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
        _hairdresserTableView.userInteractionEnabled = YES;
        [spinner removeFromSuperview];
        [spinner stopAnimating];
        [refreshControl endRefreshing];
        _isSearching = NO;
        _isRefreshing = NO;
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results){
        businesses = results;
        NSLog(@"Loaded %d business(es)", businesses.count);
        _hairdresserTableView.hidden = NO;
        [self addBusinessesToMap];
         [_hairdresserTableView reloadData];
        _hairdresserTableView.userInteractionEnabled = YES;
        [spinner removeFromSuperview];
        [spinner stopAnimating];
        [refreshControl endRefreshing];
        _isSearching = NO;
        _isRefreshing = NO;
        if (_gpsStringFromSegue != nil)
            [_hairdresserTableView setContentOffset:CGPointMake(0, 136)];
    };
    
    if (_isSearching == YES)
    {
        if(!_isRefreshing) {
            _hairdresserTableView.hidden = YES;
            [self.view addSubview:spinner];
            [spinner startAnimating];
        }
        
        GeoPoint *here = [[GeoPoint alloc] initWithString: gpsString];
        
        NSString *query;
        if (_queryNameInProgressFromSegue != nil) query = _queryNameInProgressFromSegue;
        else query = _searchView.searchByName.text;
                
        [Business listNearby:here query:query limit:@10 success:loadSuccessBlock failure:loadErrorBlock];
    }
}

// TableView Delegate Functions

/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return _headerView;
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return businesses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Business *business = businesses[indexPath.row];

    static NSString *CellIdentifier = @"similarCell";
    SimilarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimilarTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell customInit:business];
    
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rowSelected = indexPath.row;
    [self performSegueWithIdentifier:@"salonDetail" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"salonDetail"])
    {
        SalonDetailViewController *salonDetail = [segue destinationViewController];

        [salonDetail setBusiness:[businesses objectAtIndex:rowSelected]];
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
            annotationView.image = [UIImage imageNamed:@"pin-salon.png"];
            [annotationView setFrame:CGRectMake(0, 0, 17, 24)];
            annotationView.contentMode = UIViewContentModeScaleAspectFit;
            //annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height / 2);
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
