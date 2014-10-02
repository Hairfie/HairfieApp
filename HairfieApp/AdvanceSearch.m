//
//  AdvanceSearch.m
//  HairfieApp
//
//  Created by Leo Martin on 02/09/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AdvanceSearch.h"
#import "AroundMeViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation AdvanceSearch
{
    UIImageView *locationImg;
    NSString *aroundMe;
}

-(void)initView
{
    _searchAroundMeImage.image = [_searchAroundMeImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _searchBttn.layer.cornerRadius = 5;
    _searchBttn.layer.masksToBounds = YES;
    
    aroundMe = NSLocalizedStringFromTable(@"Around Me", @"Feed", nil);
}

-(IBAction)searchAroundMe:(id)sender
{
    [_searchByLocation resignFirstResponder];
    _searchByLocation.text = aroundMe;

    _searchAroundMeImage.tintColor = [UIColor lightBlueHairfie];}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _searchByLocation) {
        _searchAroundMe.enabled = YES;
        _searchAroundMeImage.tintColor = [UIColor lightGrayColor];
    }
}

-(IBAction)doSearch:(id)sender
{
    _searchRequest = [self styleSearchQuery];

    if ([_searchByLocation.text isEqualToString:@""]) {
        _searchByLocation.text = aroundMe;
    }

    [self geocodeAddress:_searchByLocation.text];
    
    
    
    [self cancelSearch:self];
}

-(IBAction)cancelSearch:(id)sender
{
    self.hidden = YES;
    [_searchByLocation resignFirstResponder];
    [_searchByName resignFirstResponder];
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
        [self doSearch:self];
        [textField resignFirstResponder];
    }
    return YES;
}

-(NSString *)styleSearchQuery
{
    NSString *searchQuery;
    
    if([_searchByLocation.text isEqualToString:aroundMe] || [_searchByLocation.text isEqualToString:@""]) {
        if ([self.searchByName.text isEqualToString:@""]) {
            
        } else {
            
        }
        
        searchQuery = [NSString stringWithFormat:NSLocalizedStringFromTable(@"\"%@\" near you", @"Feed", nil), _searchByName.text];
    } else {
        if ([_searchByName.text isEqualToString:@""])
           searchQuery = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Hairdresser around you \"%@\"", @"Feed", nil), _searchByLocation.text];
        else
        searchQuery = [NSString stringWithFormat:NSLocalizedStringFromTable(@"\"%@\" near \"%@\"", @"Feed", nil), _searchByName.text, _searchByLocation.text];
    }
    
    return searchQuery;
}

-(void)geocodeAddress:(NSString *)address
{
    if ([address isEqualToString:@"Around Me"]) {
        _gpsString = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchQuery" object:self];
    } else {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
            for (CLPlacemark* aPlacemark in placemarks)
            {
                // Process the placemark.
                NSString *latDest = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
                NSString *lngDest = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
                
                _gpsString = [NSString stringWithFormat:@"%@,%@", lngDest, latDest];
                _locationSearch =  aPlacemark.location;
              
                [[NSNotificationCenter defaultCenter] postNotificationName:@"searchQuery" object:self];

            }
        }];
    }
}

@end
