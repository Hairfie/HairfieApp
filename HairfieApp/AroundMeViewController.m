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

#import "CameraOverlayViewController.h"
#import "SearchFilterViewController.h"

#import "SalonTableViewCell.h"
#import "BusinessViewController.h"
#import "BusinessViewController.h"
#import "SimilarTableViewCell.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "LoginViewController.h"

#define ERROR_VIEW_TAG 99

#define NUM_SEARCH_RESULTS @100
#define NUM_MAP_PINS 20

@interface AroundMeViewController ()

@end

@implementation AroundMeViewController
{
    NSArray *businesses;

    NSInteger rowSelected;
    UITapGestureRecognizer *tap;
    SDWebImageManager *SDmanager;
    UIRefreshControl *refreshControl;
    UIGestureRecognizer *dismiss;
    NSString *aroundMe;
    UIView *errorView;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.showsPointsOfInterest = NO;
    aroundMe = NSLocalizedStringFromTable(@"Around Me", @"Around_Me", nil);
    businesses = [[NSArray alloc] init];
    self.delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.delegate startTrackingLocation:YES];
    self.topBarTitle.text = NSLocalizedStringFromTable(@"Find your hairdresser", @"Around_Me", nil);
    self.isSearching = YES;
    self.isRefreshing = NO;
    self.hairdresserTableView.hidden = YES;

    self.hairdresserTableView.delegate = self;
    self.hairdresserTableView.dataSource = self;
    self.hairdresserTableView.backgroundColor = [UIColor clearColor];
    self.mapView.delegate = self;
    self.hairdresserTableView.tableHeaderView = _headerView;
    [self.hairdresserTableView setSeparatorInset:UIEdgeInsetsZero];
    SDmanager = [SDWebImageManager sharedManager];

    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateSearchResults)
             forControlEvents:UIControlEventValueChanged];
    [self.hairdresserTableView addSubview:refreshControl];
    
   // [self updateSearchResults];
}

-(IBAction)modifySearchFilters:(id)sender
{
    [self performSegueWithIdentifier:@"modifySearchFilters" sender:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_delegate startTrackingLocation:YES];

    if (self.businessSearch == nil) {
        self.businessSearch = [[BusinessSearch alloc] init];
    }
    [self updateSearchResults];
    //self.searchView.businessSearch = self.businessSearch;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(businessSearchChanged:)
                                                 name:self.businessSearch.changedEventName
                                               object:self.businessSearch];
    
    [ARAnalytics pageView:@"AR - Around me"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:self.businessSearch.changedEventName
                                                  object:self.businessSearch];
}

-(void)updateSearchResults
{
    if (nil == self.businessSearch) {
        return;
    }
    
    // self.searchInProgress.text = [self.businessSearch display];
    // self.searchDesc.text = [self.businessSearch display];
    self.isSearching = YES;
    
    [self getBusinesses];
}

-(void)businessSearchChanged:(NSNotification *)notification
{
    [self updateSearchResults];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshMap
{
    // clear any existing annotation
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // toggle current location
    self.mapView.showsUserLocation = self.businessSearch.isAroundMe;

    // add business pins to the map
    NSMutableArray *annotations = [[NSMutableArray alloc] init];

    NSRange range = {0, MIN(NUM_MAP_PINS, [businesses count])};
    
    for (Business *business in [businesses subarrayWithRange:range]) {
        [annotations addObject:[self annotationForBusiness:business]];
    }

    [self.mapView addAnnotations:annotations];

    // tweak visible area of the map
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    if (self.businessSearch.isAroundMe) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(self.businessSearch.whereGeoPoint.location.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [self.mapView setVisibleMapRect:zoomRect animated:NO];
    self.mapView.camera.altitude *= 1.4;
}

-(MyAnnotation *)annotationForBusiness:(Business *)business
{
    MyAnnotation *annotObj =[[MyAnnotation alloc] init];
    annotObj.title = business.name;
    annotObj.coordinate = [[business.gps location] coordinate];
    
    return annotObj;
}

// Get Salons from webservices then add them to the map

-(void)getBusinesses
{
    self.activityIndicator.hidesWhenStopped = YES;

    //Error Block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
        _hairdresserTableView.userInteractionEnabled = YES;
        self.activityIndicator.hidden = YES;
        [refreshControl endRefreshing];
        _isSearching = NO;
        _isRefreshing = NO;
        
        [self addErrorView];
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results){
        [self removeErrorView];
        businesses = results;
        _hairdresserTableView.hidden = NO;
        [self refreshMap];
         [_hairdresserTableView reloadData];
        _hairdresserTableView.userInteractionEnabled = YES;
        self.activityIndicator.hidden = YES;
        [refreshControl endRefreshing];
        _isSearching = NO;
        _isRefreshing = NO;
    };

    if (_isSearching == YES) {
        if(!_isRefreshing) {
            _hairdresserTableView.hidden = YES;
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
        }

        
        NSLog(@"GEO POINT %@, QUERY %@, types %@", [self.businessSearch.whereGeoPoint toApiValue], self.businessSearch.query, self.businessSearch.clientTypes);
        [Business listNearby:self.businessSearch.whereGeoPoint
                       query:self.businessSearch.query
                    clientTypes:self.businessSearch.clientTypes
                       limit:NUM_SEARCH_RESULTS
                     success:loadSuccessBlock
                     failure:loadErrorBlock];
    }
}

-(void)addErrorView {
    [self.errorTextView setText: NSLocalizedStringFromTable(@"There has been an error retrieving your location. \n If you do not want to share your location, you can use the top bar to directly choose a city. \n Otherwise, try again :-)", @"Around_Me", nil)];
    self.errorTextView.hidden = NO;
}

-(void)removeErrorView {
    self.errorTextView.hidden = YES;
}

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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    headerView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:237/255.0f alpha:1];
    [headerView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];
   
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, headerView.frame.size.width, headerView.frame.size.height)];
    
    [button setTitle:NSLocalizedStringFromTable(@"Modify filters", @"Around_Me", nil) forState:UIControlStateNormal];
    

    [button.titleLabel setFont:[UIFont fontWithName:@"SourceSansPro-Light" size:20]];
   
    [button setTitleColor:[UIColor colorWithRed:132/255.0f green:137/255.0f blue:149/255.0f alpha:1] forState:UIControlStateNormal];
    
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [button addTarget:self action:@selector(modifySearchFilters:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerView.frame.size.width - 24, 19, 14, 12)];
    imageView.image = [UIImage imageNamed:@"search-filters-icon.png"];
    
    [headerView addSubview:button];
    [headerView addSubview:imageView];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"similarCell";
    SimilarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimilarTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.business = businesses[indexPath.row];
    cell.locationForDistance = self.businessSearch.whereGeoPoint;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rowSelected = indexPath.row;
    [self performSegueWithIdentifier:@"businessDetailtest" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"salonDetail"]) {
        BusinessViewController *salonDetail = [segue destinationViewController];
        [salonDetail setBusiness:[businesses objectAtIndex:rowSelected]];
    }
    if ([segue.identifier isEqualToString:@"businessDetailtest"]) {
        BusinessViewController *business = [segue destinationViewController];
        [business setBusiness:[businesses objectAtIndex:rowSelected]];
    }
    if ([segue.identifier isEqualToString:@"cameraOverlay"]) {
        CameraOverlayViewController *cameraOverlay= [segue destinationViewController];
        
        cameraOverlay.isHairfie = YES;
    }
    if ([segue.identifier isEqualToString:@"modifySearchFilters"]) {
        
        SearchFilterViewController *searchFilterVc = [segue destinationViewController];
        searchFilterVc.isModifyingSearch = YES;
        searchFilterVc.myDelegate = self;
        if (self.businessSearch != nil) {
            searchFilterVc.businessSearch = self.businessSearch;
        }
        
    }
}

- (void)didSetABusinessSearch:(BusinessSearch*)aBusinessSearch{

    self.businessSearch = aBusinessSearch;
    
    NSLog(@"business search %@", aBusinessSearch.where);

}


-(IBAction)takeHairfie:(id)sender
{
    [self checkIfCameraDisabled];
}

-(void)checkIfCameraDisabled
{
    __block BOOL isChecked = NO;
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (isChecked == NO) {
        [self performSegueWithIdentifier:@"cameraOverlay" sender:self];
            isChecked = YES;
        }
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access : %@",error.description);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning",@"Claim", nil) message:NSLocalizedStringFromTable(@"authorized access to camera", @"Post_Hairfie", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }else{
            NSLog(@"Other error code: %zi",error.code);
        }
    }];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation
{
    static NSString *myIdentifier = @"MyAnnotation";

    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:myIdentifier];
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
            annotationView.image = [UIImage imageNamed:@"pin-salon.png"];
            [annotationView setFrame:CGRectMake(0, 0, 17, 24)];
            annotationView.contentMode = UIViewContentModeScaleAspectFit;
            annotationView.canShowCallout = YES;
        }
        return annotationView;
    }
    return nil;
}

@end
