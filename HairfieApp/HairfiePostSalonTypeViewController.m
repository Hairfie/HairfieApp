//
//  HairfiePostSalonTypeViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 10/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairfiePostSalonTypeViewController.h"
#import "HairfiePostDetailsViewController.h"
#import "PostSalonTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import <LoopBack/LoopBack.h>
#import <MapKit/MapKit.h>


@implementation HairfiePostSalonTypeViewController
{
    NSArray *salons;
    NSString *gpsString;
    CLLocation *_myLocation;
    CLLocation *locationSearch;
    NSString *searchRequest;
    AppDelegate *delegate;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];
    
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    _searchAroundMeImage.image = [_searchAroundMeImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _searchByLocation.text = @"Around Me";
    _searchBttn.layer.cornerRadius = 5;
    _searchBttn.layer.masksToBounds = YES;
    _tableView.layer.borderWidth = 1;
    _tableView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [self initGpsString:_myLocation];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)searchAroundMe:(id)sender
{
    [_searchByLocation resignFirstResponder];
    _searchByLocation.text = @"Around Me";
    _searchAroundMeImage.tintColor = [UIColor lightBlueHairfie];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _searchByLocation)
    {
        _searchAroundMe.enabled = YES;
        _searchAroundMeImage.tintColor = [UIColor lightGrayColor];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        _searchAroundMe.enabled = YES;
    } else {
        [textField resignFirstResponder];
        [self doSearch:self];
    }
    return YES;
}


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
    
    static NSString *CellIdentifier = @"salonPostCell";
    PostSalonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    LBModel *model = (LBModel *)[salons objectAtIndex:indexPath.row];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostSalonTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.name.text = [model objectForKeyedSubscript:@"name"];
    [cell.salonPicture sd_setImageWithURL:[NSURL URLWithString:[model objectForKeyedSubscript:@"thumbnail"]]
                       placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    cell.address.text = [[model objectForKeyedSubscript:@"address"] valueForKey:@"street"];
    cell.city.text = [NSString stringWithFormat:@"%@ %@",[[model objectForKeyedSubscript:@"address"] valueForKey:@"city"], [[model objectForKeyedSubscript:@"address"] valueForKey:@"zipcode"]];
   
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HairfiePostDetailsViewController *details = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    details.salonChosen = [salons objectAtIndex:indexPath.row];
   
    NSLog(@"salon %@", [details.salonChosen objectForKey:@"id"]);
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [delegate startTrackingLocation:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willSearch:) name:@"searchForHairfie" object:nil];
}

-(void)willSearch:(NSNotification*)notification
{
    if ([_searchByLocation.text isEqualToString:@""] || [_searchByLocation.text isEqualToString:@"Around Me"])
        [self initGpsString:_myLocation];
    else
        [self initGpsString:locationSearch];
}


-(void) updatedLocation:(NSNotification*)notif {
    _myLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
    [self initGpsString:_myLocation];
}



-(void) initGpsString:(CLLocation *)customLocation {
    
    if (_searchByLocation != nil)
    {
        gpsString = [NSString stringWithFormat:@"%f,%f", customLocation.coordinate.longitude, customLocation.coordinate.latitude];
    }
    else
        gpsString = [NSString stringWithFormat:@"%f,%f", _myLocation.coordinate.longitude, _myLocation.coordinate.latitude];
    
    [self getSalons:gpsString];
}


-(IBAction)doSearch:(id)sender
{
    if ([_searchByLocation.text isEqualToString:@""])
    {
        _searchByLocation.text = @"Around Me";
        _searchAroundMeImage.tintColor = [UIColor lightBlueHairfie];
    }
    [self geocodeAddress:_searchByLocation.text];
    [_searchByName resignFirstResponder];
    [_searchByLocation resignFirstResponder];
}

-(void)geocodeAddress:(NSString *)address
{
    if ([address isEqualToString:@"Around Me"] || [address isEqualToString:@""]) {
        
        gpsString = [NSString stringWithFormat:@"%f,%f", _myLocation.coordinate.longitude, _myLocation.coordinate.latitude];
        NSLog(@"ucicucicuccu %@", gpsString);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchForHairfie" object:self];
    } else {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
            for (CLPlacemark* aPlacemark in placemarks)
            {
                // Process the placemark.
                NSString *latDest = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
                NSString *lngDest = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
                
                gpsString = [NSString stringWithFormat:@"%@,%@", lngDest, latDest];
                locationSearch =  aPlacemark.location;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"searchForHairfie" object:self];
                
            }
        }];
    }
}




- (void)getSalons:(NSString*)address
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setFrame:CGRectMake(150, self.view.frame.size.height/2, spinner.frame.size.width, spinner.frame.size.height)];
    spinner.hidesWhenStopped = YES;
    
    //Error Block
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
        _tableView.userInteractionEnabled = YES;
        [spinner removeFromSuperview];
        [spinner stopAnimating];
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models){
        salons = models;
        NSLog(@"Salons : %ld", [salons count]);
        _tableView.hidden = NO;
        
        _tableViewHeight.constant = [salons count] * 110;
        if (_tableViewHeight.constant > 345)
            _tableViewHeight.constant = 345;
        [_tableView reloadData];
        
        _tableView.userInteractionEnabled = YES;
        [spinner removeFromSuperview];
        [spinner stopAnimating];
    };
    
        _tableView.hidden = YES;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        NSString *repoName = @"businesses";
        NSString *query;
    
        query = _searchByName.text;
        
        _tableView.userInteractionEnabled = NO;
        [[[AppDelegate lbAdaptater] contract] addItem:[SLRESTContractItem itemWithPattern:@"/businesses/nearby" verb:@"GET"] forMethod:@"businesses.nearby"];
        
        LBModelRepository *businessData = [[AppDelegate lbAdaptater] repositoryWithModelName:repoName];
        [businessData invokeStaticMethod:@"nearby" parameters:@{@"here": gpsString, @"limit" : @"10", @"query" : query} success:loadSuccessBlock failure:loadErrorBlock];
}




@end
