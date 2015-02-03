//
//  FinalStepAddressViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 17/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "FinalStepAddressViewController.h"
#import "FinalStepViewController.h"
#import <AddressBook/AddressBook.h>
#import "GeoPoint.h"

@interface FinalStepAddressViewController ()

@end

@implementation FinalStepAddressViewController
{
    CLLocation *newLocation;
    NSString *geocodeCountry;
    BOOL geolocating;
    GeoPoint *gps;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.topBarView addBottomBorderWithHeight:1 andColor:[UIColor lightGrey]];

    gps = [[GeoPoint alloc] init];
    _street.text = _address.street;
    _city.text = _address.city;
    _zipCode.text = _address.zipCode;
   
    UIView *streetPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];

    
    _street.leftView = streetPadding;
    _street.leftViewMode = UITextFieldViewModeAlways;

    _street.layer.cornerRadius =5;
    _street.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _street.layer.borderWidth = 1;
    
    
    _street.leftView = streetPadding;
    _street.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *cityPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    
    _city.layer.cornerRadius =5;
    _city.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _city.layer.borderWidth = 1;
    _city.leftView = cityPadding;
    _city.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *zipCodePadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    
    _zipCode.layer.cornerRadius =5;
    _zipCode.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    _zipCode.layer.borderWidth = 1;
    _zipCode.leftView = zipCodePadding;
    _zipCode.leftViewMode = UITextFieldViewModeAlways;

     _doneBttn.layer.cornerRadius = 5;
    
    
    [_street becomeFirstResponder];
    // Do any additional setup after loading the view.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    Address *address = [[Address alloc] initWithStreet:_street.text city:_city.text zipCode:_zipCode.text country:nil];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        geolocating = YES;
        [self geocodeAddress:[address displayAddress]];
        [self validateAddress:self];
        [textField resignFirstResponder];
    }
    return YES;
}


-(IBAction)validateAddress:(id)sender
{
   
    // TO DO enregistrer l'adresse modifiée
       FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
   
    Address *address = [[Address alloc] initWithStreet:_street.text city:_city.text zipCode:_zipCode.text country:geocodeCountry];
    if (newLocation == nil) {
        geolocating = YES;
        [self geocodeAddress:[address displayAddress]];
        
    }
    
    while (geolocating) {
        NSLog(@"---------- Geolocatings ----------");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    

    
    if (finalStep.businessToManage != nil)
    {
        finalStep.businessToManage.address = address;
        finalStep.businessToManage.gps = gps;
    }

    [self goBack:self];
}


-(void)geocodeAddress:(NSString *)address
{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark* aPlacemark in placemarks)
        {
            // Process the placemark.
            
            newLocation =  aPlacemark.location;
            
            NSLog(@"new location lat %f lng %f", aPlacemark.location.coordinate.latitude, aPlacemark.location.coordinate.longitude);
           
            geolocating = NO;
            gps.lat = [NSNumber numberWithFloat:aPlacemark.location.coordinate.latitude];
            gps.lng = [NSNumber numberWithFloat:aPlacemark.location.coordinate.longitude];
            [self reverseGeocodeGps:newLocation];
        }
    }];
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

                           NSString *country = [addressDictionary objectForKey:(NSString*)kABPersonAddressCountryKey];
                           geocodeCountry = country;
                       }
                       
                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
