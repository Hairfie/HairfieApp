
//
//  ThirdStepViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 16/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ThirdStepViewController.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "ThirdStepMapViewController.h"
#import "Address.h"
#import "GeoPoint.h"


@interface ThirdStepViewController ()

@end

@implementation ThirdStepViewController
{
    CLLocation *_location;
    AppDelegate *delegate;
    NSString *_country;
}

 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"3RD STEP CLAIM %@", _claim);
    delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];
    
    UIView *addressPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    UIView *postalPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    UIView *cityPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    
    
    _address.layer.cornerRadius =5;
    _address.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _address.layer.borderWidth = 1;
    _address.leftView = addressPadding;
    _address.leftViewMode = UITextFieldViewModeAlways;
    
    _city.layer.cornerRadius =5;
    _city.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _city.layer.borderWidth = 1;
    _city.leftView = postalPadding;
    _city.leftViewMode = UITextFieldViewModeAlways;
    
    _postalCode.layer.cornerRadius =5;
    _postalCode.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _postalCode.layer.borderWidth = 1;
    _postalCode.leftView = cityPadding;
    _postalCode.leftViewMode = UITextFieldViewModeAlways;
    
    _currentAddressBttn.layer.cornerRadius =5;
    _currentAddressBttn.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _currentAddressBttn.layer.borderWidth = 1;
    
    _nextButton.layer.cornerRadius = 5;
    // Do any additional setup after loading the view.
}


-(void) updatedLocation:(NSNotification*)notif {
    _location = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [delegate startTrackingLocation:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];
}


-(void)reverseGeocodeGps:(CLLocation*)myLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:myLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       if (error) {
                           NSLog(@"Geocode failed with error: %@", error);
                           return;
                       }
                       if (placemarks && placemarks.count > 0)
                       {
                           CLPlacemark *placemark = placemarks[0];
                           NSDictionary *addressDictionary =
                           placemark.addressDictionary;
                           NSString *address = [addressDictionary
                                                objectForKey:(NSString *)kABPersonAddressStreetKey];
                           NSString *city = [addressDictionary
                                             objectForKey:(NSString *)kABPersonAddressCityKey];
                           NSString *zip = [addressDictionary
                                            objectForKey:(NSString *)kABPersonAddressZIPKey];
                           NSString *country = [addressDictionary objectForKey:(NSString*)kABPersonAddressCountryKey];
                           
                           
                           _address.text = address;
                           _city.text = city;
                           _postalCode.text = zip;
                           _country = country;
                       }
                       
                   }];
}

-(void)geocodeAddress:(NSString *)address
{
    
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
            for (CLPlacemark* aPlacemark in placemarks)
            {
                // Process the placemark.
                
                _location =  aPlacemark.location;
                
                NSLog(@"location %f,%f", _location.coordinate.latitude, _location.coordinate.longitude);
            }
        }];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
     NSString *address = [NSString stringWithFormat:@"%@ %@ %@", _address.text, _city.text, _postalCode.text];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self claimSalonLocation:self];
    }
    [self geocodeAddress:address];
    return YES;
}

-(IBAction)setAddressByLocation:(id)sender
{
    [self reverseGeocodeGps:_location];
    [_address resignFirstResponder];
    [_city resignFirstResponder];
    [_postalCode resignFirstResponder];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)claimSalonLocation:(id)sender
{
    if(![_address hasText] || ![_city hasText] || ![_postalCode hasText]) {
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Warning", @"Claim", nil) message:NSLocalizedStringFromTable(@"Please fill in your address !", @"Claim", nil)delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    } else {
        Address *address = [[Address alloc] initWithStreet:_address.text city:_city.text zipCode:_postalCode.text country:_country];
        [self geocodeAddress:[address displayAddress]];
        
        GeoPoint *gps = [[GeoPoint alloc] initWithLocation:_location];
        
        _claim.address = address;
        _claim.gps = gps;
        
        void (^loadErrorBlock)(NSError *) = ^(NSError *error){
            NSLog(@"Error : %@", error.description);
        };
        void (^loadSuccessBlock)(NSDictionary *) = ^(NSDictionary *results){
            //NSLog(@"results %@", results);
            _claim.id = [results objectForKey:@"id"];
            [self performSegueWithIdentifier:@"claimBusinessMapLocation" sender:self];
        };
        
        [_claim claimWithSuccess:loadSuccessBlock failure:loadErrorBlock];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"claimBusinessMapLocation"])
    {
        ThirdStepMapViewController *businessMap = [segue destinationViewController];
        businessMap.businessLocation = _location;
        businessMap.claim = [[BusinessClaim alloc] init];
        businessMap.claim = _claim;
    }
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
