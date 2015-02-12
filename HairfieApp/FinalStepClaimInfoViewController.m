//
//  FinalStepClaimInfoViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 2/11/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "FinalStepClaimInfoViewController.h"
#import "FinalStepClaimDayViewController.h"
#import "FinalStepViewController.h"
#import "SecondStepViewController.h"

#import "ClaimTimetableCell.h"
#import "UITextField+Style.h"
#import "NSString+PhoneFormatter.h"
#import "Day.h"
#import "TimeWindow.h"
#import "Week.h"
#import <AddressBook/AddressBook.h>

@interface FinalStepClaimInfoViewController ()

@end

@implementation FinalStepClaimInfoViewController
{
    // Timetable
    Day *dayPicked;
    NSArray *weekDays;
    // Address
    CLLocation *newLocation;
    NSString *geocodeCountry;
    BOOL geolocating;
    GeoPoint *gps;
    //Business Info
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.validateBttn.layer.cornerRadius = 5;
    self.daysTableView.hidden = YES;
    self.addressContainerView.hidden = YES;
    self.businessInfoContainerView.hidden = YES;
   
    self.headerLabel.text = self.headerTitle;
    
    // TimeTable
    if (_timeTable == nil)
        _timeTable = [[Timetable alloc] initEmpty];
    
    
    weekDays = [[[Week alloc] init] weekdays];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearDay:)
                                                 name:@"clearDay"
                                               object:nil];

    // Address
    gps = [[GeoPoint alloc] init];
    self.street.text = self.address.street;
    self.city.text = self.address.city;
    self.zipCode.text = self.address.zipCode;
    
    UIView *streetPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    self.street.leftView = streetPadding;
    self.street.leftViewMode = UITextFieldViewModeAlways;
    UIView *cityPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    self.city.leftView = cityPadding;
    self.city.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *zipCodePadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    
    self.zipCode.leftView = zipCodePadding;
    self.zipCode.leftViewMode = UITextFieldViewModeAlways;
    
    // Business Info
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValidated:) name:@"validateTextField" object:nil];
    
    self.textField.placeholder = self.textFieldPlaceHolder;
    
    UIView *fieldPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 46)];
    if (self.isExisting == YES)
    {
        self.textField.text = self.textFieldFromSegue;
    }
    if (self.isSalon == NO) {
        [self.textField textFieldWithPhoneKeyboard:(self.view.frame.size.width / 2 - 50)];
    }
    self.textField.leftView = fieldPadding;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.returnKeyType = UIReturnKeyDone;
    


}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.isTimetable == YES) {
        self.daysTableView.hidden = NO;
        self.addressContainerView.hidden = YES;
        self.businessInfoContainerView.hidden = YES;
        [self.daysTableView reloadData];
    }
    else if (self.isAddress == YES) {
        self.daysTableView.hidden = YES;
        self.addressContainerView.hidden = NO;
        self.businessInfoContainerView.hidden = YES;
        [self.street becomeFirstResponder];
    }
    else if (self.isBusinessInfo == YES) {
        self.daysTableView.hidden = YES;
        self.addressContainerView.hidden = YES;
        self.businessInfoContainerView.hidden = NO;
        [self.textField becomeFirstResponder];
    }
}

-(IBAction)goBack:(id)sender {
    if (self.isBusinessInfo) {
        if (_isSalon == YES)
            [self validate:nil];
        else
            [self.navigationController popViewControllerAnimated:YES];
    } else
        [self.navigationController popViewControllerAnimated:YES];
}

// NOTIFICATIONS

-(void)clearDay:(NSNotification*)notification {
    ClaimTimetableCell *cell = notification.object;
    [self.timeTable clearDayInteger:cell.tag];
    [self.daysTableView reloadData];
}

-(void)textFieldValidated:(NSNotification*)notification {
    [self validate:nil];
}


/// VALIDATION

-(void)validateTimetable {

    FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    
    
    if (finalStep.businessToManage != nil)
        finalStep.businessToManage.timetable = _timeTable;
    [self goBack:self];

}

-(void)validateAddress {
    FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    
    [self.activityIndicator startAnimating];
    Address *address = [[Address alloc] initWithStreet:_street.text city:_city.text zipCode:_zipCode.text country:geocodeCountry];
    if (newLocation == nil) {
        geolocating = YES;
        [self geocodeAddress:[address displayAddress]];
        
    }
    
    while (geolocating) {
        NSLog(@"---------- Geolocating ----------");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
    
    if (finalStep.businessToManage != nil)
    {
        finalStep.businessToManage.address = address;
        finalStep.businessToManage.gps = gps;
    }
    [self goBack:self];
    [self.activityIndicator stopAnimating];

}

-(void)validateBusinessInfo {
    BOOL isPhoneValid = NO;
    
    if (self.isFinalStep == NO){
        SecondStepViewController *claim = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        
        if (_isSalon == NO)
        {
            
            isPhoneValid = [self.textField.text checkPhoneValidity:self.textField.text];
            if (isPhoneValid == YES) {
                [self.navigationController popViewControllerAnimated:YES];
                claim.phoneTextField.text = self.textField.text;
                claim.isPhoneSet = YES;
            }
        }
        else
        {
            claim.isSalonSet = YES;
            claim.salonTextField.text = self.textField.text;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else
    {
        FinalStepViewController *finalStep = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
        
        if (finalStep.businessToManage != nil) {
            if (self.isSalon == NO) {
                isPhoneValid = [self.textField.text checkPhoneValidity:self.textField.text];
                if (isPhoneValid == YES) {
                    [self.navigationController popViewControllerAnimated:YES];
                    finalStep.businessToManage.phoneNumber = self.textField.text;
                }
            } else {
                finalStep.businessToManage.name = self.textField.text;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }

}

-(IBAction)validate:(id)sender
{
    if (self.isTimetable == YES)
        [self validateTimetable];
    else if (self.isAddress == YES)
        [self validateAddress];
    else if (self.isBusinessInfo == YES)
        [self validateBusinessInfo];
}

// TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (self.isAddress == YES) {
    Address *address = [[Address alloc] initWithStreet:_street.text city:_city.text zipCode:_zipCode.text country:nil];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        geolocating = YES;
        [self geocodeAddress:[address displayAddress]];
        [self validate:self];
        [textField resignFirstResponder];
    }
    return YES;
    }
    else if (self.isBusinessInfo == YES){
        [self.textField resignFirstResponder];
        [self validate:nil];
        return YES;
    }
    
    
    return NO;
}

/// Timetable

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dayPicked = [weekDays objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"addTimeWindow" sender:self];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"claimTimetableCell";
    ClaimTimetableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClaimTimetableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Day *currentDay = [weekDays objectAtIndex:indexPath.row];
    cell.day.text = currentDay.name;
    
    NSArray *currentTimeWindows = [_timeTable performSelector:currentDay.selector];
    
    if ([currentTimeWindows count] != 0) {
        NSString *display = @"";
        for (TimeWindow *tm in currentTimeWindows) {
            if ([display isEqualToString:@""]){
                display = [tm timeWindowFormatted];
            } else {
                display = [NSString stringWithFormat:@"%@ / %@", display, [tm timeWindowFormatted]];
            }
        }
        cell.timewindow.text = display;
        cell.deleteButton.hidden = NO;
        cell.tag = indexPath.row;
    } else {
        cell.timewindow.text = NSLocalizedStringFromTable(@"Set a time window", @"Claim", nil);
        cell.deleteButton.hidden = YES;
    }
    
    cell.tag = indexPath.row;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addTimeWindow"])
    {
        FinalStepClaimDayViewController *claimDay = [segue destinationViewController];
        claimDay.dayPicked = dayPicked;
    }
}

// Address

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


@end
