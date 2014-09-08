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


@interface AroundMeViewController ()

@end

@implementation AroundMeViewController
{
    NSArray *salons;
    CLLocation *myLocation;
    NSInteger rowSelected;
    UITapGestureRecognizer *tap;
    SDWebImageManager *SDmanager;
    NSString *gpsString;
}
@synthesize manager = _manager, geocoder = _geocoder, mapView = _mapView, hairdresserTableView = _hairdresserTableView, delegate = _delegate, myLocation = _myLocation;


- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];

   
    
   // _searchInProgress.text = _searchInProgressFromSegue;
   // _searchDesc.text = _searchInProgressFromSegue;
    
    _isSearching = YES;
     _hairdresserTableView.hidden = YES;
    [_searchView initView];
    
    if (_searchInProgressFromSegue == nil)
    {
        [_searchView.searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
        _searchView.searchByLocation.text = @"Around Me";
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
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [_delegate startTrackingLocation:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willSearch:) name:@"searchQuery" object:nil];
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
    if (![_searchView.searchByName.text isEqualToString:@""] && [_searchView.searchByLocation.text isEqualToString:@"Around Me"])
    {
        NSLog(@"labas");
        if ([_searchView.searchByName.text isEqualToString:@""])
            _searchDesc.text = @"COIFFEURS À COTÉ DE VOUS";
        else
            _searchDesc.text = [NSString stringWithFormat:@"%@ À COTÉ DE VOUS", [_searchView.searchByName.text uppercaseString]];
    }
    else
    {
        _searchDesc.text = _searchView.searchRequest;
        [self initMapWithSalons:_searchView.locationSearch];
        [_hairdresserTableView setContentOffset:CGPointMake(0, 136)];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    _searchView.hidden = NO;
    if ([_searchView.searchByLocation.text isEqualToString:@"Around Me"])
        [_searchView.searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
    [_searchView.searchByName performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) updatedLocation:(NSNotification*)notif {
    
    if (_gpsStringFromSegue != nil)
    {
        _searchDesc.text = _searchInProgressFromSegue;
        [self initMapWithSalons:_locationFromSegue];
    }
    else
    {
        NSLog(@"query %@", _queryNameInProgressFromSegue);
        _myLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
        if (_queryNameInProgressFromSegue != nil) {
            _searchView.searchByName.text = _queryNameInProgressFromSegue;
        }
        
        if (_searchInProgressFromSegue != nil)
            _searchDesc.text = _searchInProgressFromSegue;
        [self initMapWithSalons:nil];
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
// Get Salons from webservice

-(void) initMapWithSalons:(CLLocation *)customLocation {

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
        [self getSalons:_gpsStringFromSegue];
        
    }
    else
    {
        [self getSalons:gpsString];
    }
    //[_mapView setRegion:region animated:NO];
}



-(void) addSalonsToMap {
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for ( int i= 0; i<[salons count]; i++) {
        NSDictionary *salon = [salons objectAtIndex:i];
        [annotations addObject:[self annotationForSalon:salon]];
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

// Add a salon to the map

- (MyAnnotation *) annotationForSalon: (NSDictionary *) salon {
    
    NSDictionary *coords = [salon valueForKey:@"gps"];
    NSString *titleStr = [salon valueForKey:@"name"];
    
    CLLocationCoordinate2D coord;
    coord.longitude = [[NSString stringWithFormat:@"%@",[coords valueForKey:@"lng"]] floatValue];
    coord.latitude = [[NSString stringWithFormat:@"%@",[coords valueForKey:@"lat"]] floatValue];
    
    MyAnnotation *annotObj =[[MyAnnotation alloc]init];
    annotObj.title = titleStr;
    annotObj.coordinate = coord;
    
    return annotObj;
}

// Get Salons from webservices then add them to the map

- (void)getSalons:(NSString*)address
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
        _isSearching = NO;
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models){
        salons = models;
        NSLog(@"Salons : %@", salons);
        _hairdresserTableView.hidden = NO;
        [self addSalonsToMap];
         [_hairdresserTableView reloadData];
        _hairdresserTableView.userInteractionEnabled = YES;
        [spinner removeFromSuperview];
        [spinner stopAnimating];
        _isSearching = NO;
        if (_gpsStringFromSegue != nil)
            [_hairdresserTableView setContentOffset:CGPointMake(0, 136)];
    };
    
    if (_isSearching == YES)
    {
        _hairdresserTableView.hidden = YES;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        NSString *repoName = @"businesses";
        NSString *query;
       if (_queryNameInProgressFromSegue != nil)
           query = _queryNameInProgressFromSegue;
        else
            query = _searchView.searchByName.text;
        
        _hairdresserTableView.userInteractionEnabled = NO;
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/nearby" verb:@"GET"] forMethod:@"businesses.nearby"];

        LBModelRepository *businessData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
        [businessData invokeStaticMethod:@"nearby" parameters:@{@"here": gpsString, @"limit" : @"10", @"query" : query} success:loadSuccessBlock failure:loadErrorBlock];
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
    return [salons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSDictionary *salon = [salons objectAtIndex:indexPath.row];
   // NSDictionary *price = [salon objectForKey:@"price"];

    LBModel *model = (LBModel *)[salons objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"similarCell";
    SimilarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimilarTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:[model objectForKeyedSubscript:@"thumb"]]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {

             cell.salonPicture.image = image;
         }
     }];

    cell.name.text = [model objectForKeyedSubscript:@"name"];
    [cell customInit:model];
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
