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

@interface ThirdStepViewController ()

@end

@implementation ThirdStepViewController
{
    CLLocation *_location;
    AppDelegate *delegate;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
                           _address.text = address;
                           _city.text = city;
                           _postalCode.text = zip;
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
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        NSString *address = [NSString stringWithFormat:@"%@ %@ %@", _address.text, _city.text, _postalCode.text];
        
        [self geocodeAddress:address];
        [textField resignFirstResponder];
    }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"claimBusinessMap"])
    {
        ThirdStepMapViewController *businessMap = [segue destinationViewController];
        businessMap.businessLocation = _location;
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
