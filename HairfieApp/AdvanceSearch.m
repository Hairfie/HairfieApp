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
    _searchAroundMeImage.tintColor = [UIColor lightBlueHairfie];

    _searchBttn.backgroundColor = [UIColor salonDetailTab];
    _searchBttn.layer.cornerRadius = 5;
    _searchBttn.layer.masksToBounds = YES;

    aroundMe = NSLocalizedStringFromTable(@"Around Me", @"Feed", nil);

    [self refreshView];
}

-(void)setBusinessSearch:(BusinessSearch *)businessSearch
{
    _businessSearch = businessSearch;
    [self refreshView];
}

-(void)refreshView
{
    if (nil == self.businessSearch) {
        self.searchByName.text = @"";
    } else {
        self.searchByName.text = self.businessSearch.query;
        self.searchByLocation.text = self.businessSearch.where;
    }

    if ([self.searchByLocation
         .text isEqualToString:@""]) {
        self.searchByLocation.text = aroundMe;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _searchByLocation) {
        _searchAroundMe.enabled = YES;
        _searchAroundMeImage.tintColor = [UIColor lightGrayColor];
    }
}

-(IBAction)searchAroundMe:(id)sender
{
    [_searchByLocation resignFirstResponder];
    self.searchByLocation.text = aroundMe;
    self.searchAroundMeImage.tintColor = [UIColor lightBlueHairfie];
}

-(IBAction)doSearch:(id)sender
{
    if ([self.searchByLocation.text isEqualToString:@""]) {
        self.searchByLocation.text = aroundMe;
    }

    self.businessSearch.query = self.searchByName.text;

    if ([self.searchByLocation.text isEqualToString:aroundMe]) {
        self.businessSearch.where = @"";
    } else {
        self.businessSearch.where = self.searchByLocation.text;
    }

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
        self.searchAroundMe.enabled = YES;
    } else {
        [self doSearch:self];
        [textField resignFirstResponder];
    }
    return YES;
}

@end
