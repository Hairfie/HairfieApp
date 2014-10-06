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

    NSInteger rowSelected;
    UITapGestureRecognizer *tap;
    SDWebImageManager *SDmanager;
    UIRefreshControl *refreshControl;
    UIGestureRecognizer *dismiss;
    NSString *aroundMe;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    aroundMe = NSLocalizedStringFromTable(@"Around Me", @"Around_Me", nil);

    self.delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.delegate startTrackingLocation:YES];

    dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.isSearching = YES;
    self.isRefreshing = NO;
    self.hairdresserTableView.hidden = YES;
    [self.searchView initView];
    self.searchView.hidden = YES;

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
    
    [self updateSearchResults];
}


-(void)hideKeyboard
{
    [_searchView.searchByLocation resignFirstResponder];
    [_searchView.searchByName resignFirstResponder];
    _searchView.hidden = YES;
    [self.view removeGestureRecognizer:dismiss];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_delegate startTrackingLocation:YES];

    if (nil == self.businessSearch) {
        NSLog(@"Creating brand new business search...");
        self.businessSearch = [[BusinessSearch alloc] init];
        [self updateSearchResults];
    }
    
    self.searchView.businessSearch = self.businessSearch;

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
    
    self.searchInProgress.text = self.businessSearch.display;
    self.searchDesc.text = self.businessSearch.display;
    self.isSearching = YES;
    
    [self getBusinesses];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    _searchView.hidden = NO;
    if ([self.searchView.searchByLocation.text isEqualToString:aroundMe]) {
        [self.searchView.searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
    }
    [_searchView.searchByName performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
    [self.view addGestureRecognizer:dismiss];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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
    for (Business *business in businesses) {
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
        _hairdresserTableView.hidden = NO;
        [self refreshMap];
         [_hairdresserTableView reloadData];
        _hairdresserTableView.userInteractionEnabled = YES;
        [spinner removeFromSuperview];
        [spinner stopAnimating];
        [refreshControl endRefreshing];
        _isSearching = NO;
        _isRefreshing = NO;
    };

    if (_isSearching == YES) {
        if(!_isRefreshing) {
            _hairdresserTableView.hidden = YES;
            [self.view addSubview:spinner];
            [spinner startAnimating];
        }

        [Business listNearby:self.businessSearch.whereGeoPoint
                       query:self.businessSearch.query
                       limit:@10
                     success:loadSuccessBlock
                     failure:loadErrorBlock];
    }
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
    [self performSegueWithIdentifier:@"salonDetail" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"salonDetail"]) {
        SalonDetailViewController *salonDetail = [segue destinationViewController];
        [salonDetail setBusiness:[businesses objectAtIndex:rowSelected]];
    }
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
