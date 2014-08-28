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

#

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
    _isSearching = YES;
     _hairdresserTableView.hidden = YES;
    _searchHeaderView.hidden = YES;
     _searchByName.delegate = self;
    _hairdresserTableView.delegate = self;
    _hairdresserTableView.dataSource = self;
    _hairdresserTableView.backgroundColor = [UIColor clearColor];
    _searchAroundMe.enabled = NO;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _hairdresserTableView.tableHeaderView = _headerView;
    [_hairdresserTableView setSeparatorInset:UIEdgeInsetsZero];
    _searchBttn.layer.cornerRadius = 5;
    _searchBttn.layer.masksToBounds = YES;
    _searchAroundMeImage.image = [_searchAroundMeImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
    _searchByLocation.text = @"Around Me";
    SDmanager = [SDWebImageManager sharedManager];
    // Do any additional setup after loading the view.
}

-(IBAction)searchAroundMe:(id)sender
{
    [_searchByLocation resignFirstResponder];
    _searchByLocation.text = @"Around Me";
  //  _searchByLocation.textColor = [UIColor lightBlueHairfie];

    [_searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
}

-(IBAction)cancelSearch:(id)sender
{
    _searchHeaderView.hidden = YES;
    [_searchField resignFirstResponder];
    [_searchByLocation resignFirstResponder];
    [_searchByName resignFirstResponder];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (IBAction)showAdvancedSearch:(id)sender{
    _searchHeaderView.hidden = NO;
    if ([_searchByLocation.text isEqualToString:@"Around Me"])
    [_searchAroundMeImage setTintColor:[UIColor lightBlueHairfie]];
    [_searchByName performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.0];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        _searchByLocation.text = @"";
        _searchAroundMe.enabled = YES;
    } else {
        [self doSearch:self];
    }
    return YES;
}

-(IBAction)doSearch:(id)sender
{
    if([_searchByLocation.text length] == 0) {
        _searchByLocation.text = @"Around Me";
    }
    [_mapView removeAnnotations:_mapView.annotations];

    NSString *searchQuery = [self styleSearchQuery];
    _searchInProgress.text = searchQuery;
    NSString *queryLocation = _searchByLocation.text;
     _isSearching = YES;
    UIView *headerSearch = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 310, 30)];
    searchLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:16];
    searchLabel.textColor = [UIColor colorWithRed:109/255.0f green:118/255.0f blue:131/255.0f alpha:1];

    searchLabel.text = searchQuery;
    [headerSearch addSubview:searchLabel];

    if ([_searchByLocation.text isEqualToString:@"Around Me"])
    {
        _hairdresserTableView.tableHeaderView = _headerView;
       if (![_searchByName.text isEqualToString:@""])
        _searchDesc.text = [NSString stringWithFormat:@"%@ À COTÉ DE VOUS", [_searchByName.text uppercaseString]];
        else
            _searchDesc.text = @"COIFFEURS À COTÉ DE VOUS";
    }
    else
        _hairdresserTableView.tableHeaderView = headerSearch;
    [self geocodeAddress:queryLocation];
    [self cancelSearch:self];
}

- (NSString*) styleSearchQuery {
    NSString *searchQuery;
    if([_searchByLocation.text isEqualToString:@"Around Me"]) {
        searchQuery = [NSString stringWithFormat:@"\"%@\" à côté de vous", _searchByName.text];
    } else {
       searchQuery = [NSString stringWithFormat:@"\"%@\" à côté de \"%@\"", _searchByName.text, _searchByLocation.text];
    }


    return searchQuery;
}

-(void)geocodeAddress:(NSString *)address
{
    if ([address isEqualToString:@"Around Me"]) {
        [self initMapWithSalons:nil];
    } else {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
            for (CLPlacemark* aPlacemark in placemarks)
            {
                // Process the placemark.
                NSString *latDest = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
                NSString *lngDest = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];

                gpsString = [NSString stringWithFormat:@"%@,%@", lngDest, latDest];
                [self initMapWithSalons:aPlacemark.location];
            }
        }];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _searchByLocation)
    {
        _searchAroundMe.enabled = YES;
        _searchAroundMeImage.tintColor = [UIColor lightGrayColor];
        textField.text = @"";
    }
}

//METHODES pour cacher/afficher la tableview et agrandir la mapview dans la recherche

-(void)hideTableView:(UIGestureRecognizer*)gesture
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.4];
    [_mapView setFrame:CGRectMake(0, 0, _mapView.frame.size.width, 456)];
    [_scrollView scrollRectToVisible:CGRectMake(0, -464, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    [_mapView removeGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTableView:)];
    [_hairdresserTableView addGestureRecognizer:tap];
    [UIView commitAnimations];
}

-(void) showTableView:(UIGestureRecognizer*)gesture
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.4];
    [_mapView setFrame:CGRectMake(0, 0, _mapView.frame.size.width, 220)];
    [_scrollView scrollRectToVisible:CGRectMake(0, -220, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:NO];
    [_hairdresserTableView removeGestureRecognizer:tap];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTableView:)];
    [_mapView addGestureRecognizer:tap];
    [UIView commitAnimations];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) updatedLocation:(NSNotification*)notif {
    _myLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
    gpsString = [NSString stringWithFormat:@"%f,%f", _myLocation.coordinate.longitude, _myLocation.coordinate.latitude];

    [self initMapWithSalons:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [_delegate startTrackingLocation:YES];
  //  userLocation = _mapView.userLocation;

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

    }
     [self getSalons:gpsString];
    [_mapView setRegion:region animated:NO];

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

    NSDictionary *coords = [salon valueForKey:@"gps"];
    NSString *titleStr = [salon valueForKey:@"name"];

    CLLocationCoordinate2D coord;
    coord.longitude = [[NSString stringWithFormat:@"%@",[coords valueForKey:@"lng"]] floatValue];
    coord.latitude = [[NSString stringWithFormat:@"%@",[coords valueForKey:@"lat"]] floatValue];

    MyAnnotation *annotObj =[[MyAnnotation alloc]init];
    annotObj.title = titleStr;
    annotObj.coordinate = coord;
    [_mapView addAnnotation:annotObj];
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
        _hairdresserTableView.hidden = NO;
        [self addSalonsToMap];
         [_hairdresserTableView reloadData];
        _hairdresserTableView.userInteractionEnabled = YES;
        [spinner removeFromSuperview];
        [spinner stopAnimating];
        _isSearching = NO;
    };



    if (_isSearching == YES)
    {
        _hairdresserTableView.hidden = YES;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        NSString *repoName = @"businesses";
        _hairdresserTableView.userInteractionEnabled = NO;
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/nearby" verb:@"GET"] forMethod:@"businesses.nearby"];

        LBModelRepository *businessData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
        [businessData invokeStaticMethod:@"nearby" parameters:@{@"here": address, @"limit" : @"10", @"query" : _searchByName.text} success:loadSuccessBlock failure:loadErrorBlock];
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

    if ( indexPath.row % 2 == 0)//[[price objectForKey:@"women"] integerValue] != 0 && [[price objectForKey:@"men"]integerValue] != 0)
    {
        static NSString *CellIdentifier = @"salonCell";
        SalonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SalonTableViewCell" owner:self options:nil];
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



        [cell customInit:model];
        return cell;

        }



    else
    {
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

    return nil;
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
