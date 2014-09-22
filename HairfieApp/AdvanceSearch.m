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
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initView
{
    _searchAroundMeImage.image = [_searchAroundMeImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _searchBttn.layer.cornerRadius = 5;
    _searchBttn.layer.masksToBounds = YES;
}

-(IBAction)searchAroundMe:(id)sender
{
    [_searchByLocation resignFirstResponder];
    _searchByLocation.text = NSLocalizedStringFromTable(@"Around Me", @"Feed", nil);
   
    _searchAroundMeImage.tintColor = [UIColor lightBlueHairfie];
    
    //[_searchAroundMeImage setTintColor:[UIColor redColor]];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _searchByLocation)
    {
        _searchAroundMe.enabled = YES;
        _searchAroundMeImage.tintColor = [UIColor lightGrayColor];
    }
}

-(IBAction)doSearch:(id)sender
{
    _searchRequest = [self styleSearchQuery];
    if ([_searchByLocation.text isEqualToString:@""])
        _searchByLocation.text = NSLocalizedStringFromTable(@"Around Me", @"Feed", nil);
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

- (NSString*) styleSearchQuery {
    NSString *searchQuery;
    if([_searchByLocation.text isEqualToString:NSLocalizedStringFromTable(@"Around Me", @"Feed", nil)] || [_searchByLocation.text isEqualToString:@""] ) {
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


/*
-(void) useless
{
 UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 142)];
 containerView.backgroundColor = [UIColor colorWithRed:50 green:67 blue:87 alpha:1];
 
 UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
 topView.backgroundColor = [UIColor colorWithRed:40 green:49 blue:57 alpha:1];
 
 UILabel *searchLbl = [[UILabel alloc] initWithFrame:CGRectMake(122, 27, 76, 21)];
 searchLbl.text = @"Recherche";
 searchLbl.font = [UIFont fontWithName:@"SourceSansPro-Light" size:16];
 
 UIButton *searchBttn = [UIButton buttonWithType:UIButtonTypeCustom];
 [searchBttn setFrame:CGRectMake(220, 27, 90, 27)];
 searchBttn.backgroundColor = [UIColor colorWithRed:223 green:98 blue:85 alpha:1];
 searchBttn.layer.cornerRadius = 5;
 searchBttn.layer.masksToBounds = YES;
 searchBttn.titleLabel.text = @"Rechercher";
 
 
 UIButton *cancelBttn = [UIButton buttonWithType:UIButtonTypeCustom];
 UIImage *cancelImg = [UIImage imageNamed:@"arrow-nav.png"];
 [cancelBttn setImage:cancelImg forState:UIControlStateNormal];
 [cancelBttn addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
 [cancelBttn setFrame:CGRectMake(10, 26, 20, 20)];
 
 [topView addSubview:searchBttn];
 [topView addSubview:searchLbl];
 [topView addSubview:cancelBttn];
 
 
 
 UIImageView *nameSearchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 73, 300, 27)];
 nameSearchImgView.image = [UIImage imageNamed:@"search-advance-field-name.png"];
 UITextField *nameSearchTxtField = [[UITextField alloc] initWithFrame:CGRectMake(54, 73, 254, 27)];
 nameSearchTxtField.placeholder = @"Ex : Lissage brésilien, coloration, rouge...";
 nameSearchTxtField.font = [UIFont fontWithName:@"SourceSansPro-Light" size:14];
 UIImageView *locationSearchImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 108, 300, 27)];
 locationSearchImgView.image = [UIImage imageNamed:@"search-advance-field-location.png"];
 UITextField *locationSearchTxtField = [[UITextField alloc] initWithFrame:CGRectMake(54, 108, 254, 27)];
 locationSearchTxtField.placeholder = @"Ex : Paris, Marseille...";
 locationSearchTxtField.font = [UIFont fontWithName:@"SourceSansPro-Light" size:14];
 
 
 locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(21, 114, 12, 16)];
 locationImg.image = [UIImage imageNamed:@"location-button-image.png"];
 [locationImg.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
 [locationImg setTintColor:[UIColor lightBlueHairfie]];
 
 UIButton *locationBttn = [UIButton buttonWithType:UIButtonTypeCustom];
 [locationBttn setFrame:CGRectMake(8, 108, 38, 27)];
 [cancelBttn addTarget:self action:@selector(searchAroundMe:) forControlEvents:UIControlEventTouchUpInside];
 
 [containerView addSubview:nameSearchImgView];
 [containerView addSubview:nameSearchTxtField];
 [containerView addSubview:locationSearchImgView];
 [containerView addSubview:locationSearchTxtField];
 [containerView addSubview:locationImg];
 [containerView addSubview:locationBttn];
 [containerView addSubview:topView];
}
*/

@end
