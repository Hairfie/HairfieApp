//
//  BusinessDetailCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AppDelegate.h"
#import "BusinessDetailCollectionViewCell.h"
#import "NSString+PhoneFormatter.h"
#import "ReviewTableViewCell.h"
#import "SimilarTableViewCell.h"
#import "BusinessReview.h"

#define NUM_REVIEWS 2
#define NUM_SIMILAR_BUSINESSES 3
#define REVIEW_ROW_HEIGHT 130

@implementation BusinessDetailCollectionViewCell
{
    BOOL loadingReviews;
    NSArray *reviews;
    NSArray *similarBusinesses;
    Business *business;
    AppDelegate *appDelegate;
}
- (void)awakeFromNib {
    // Initialization code
}


-(void)setupDetails:(Business*)aBusiness
{
    business = aBusiness;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.reviewTableView.delegate = self;
    self.reviewTableView.dataSource = self;
    self.similarTableView.delegate = self;
    self.similarTableView.dataSource = self;
    self.seeDetailsLbl.text = NSLocalizedStringFromTable(@"seeDetails", @"Salon_Detail", nil);
    self.similarBusinessesLbl.text = NSLocalizedStringFromTable(@"similarBusinesses", @"Salon_Detail", nil);
    [self setupCrossSell];
    [self setupReviews];
    self.address.text = business.address.street;
    self.city.text = [business.address displayCityAndZipCode];

    
    if ([business.phoneNumber isEqual:[NSNull null]]) {
        self.telephone.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"No phone number", @"Salon_Detail", nil)];
        self.telephoneLabelWidth.constant = 133;
    } else {
        [self addPhoneNumbersToView];
        
    }

    if (nil == business.timetable) {
        self.isOpenImageDetail.hidden = YES;
        self.isOpenLabelDetail.hidden = YES;
        self.isOpenLabel.text = NSLocalizedStringFromTable(@"No information", @"Salon_Detail", nil);
    } else {
        if (business.timetable.isOpenToday) {
            if ([business.kind isEqualToString:KIND_ATHOME]) {
                self.isOpenLabel.text = NSLocalizedStringFromTable(@"Works today", @"Salon_Detail", nil);
            } else {
                self.isOpenLabel.text = NSLocalizedStringFromTable(@"Open today", @"Salon_Detail", nil);
            }
            self.isOpenLabel.textColor = [UIColor greenHairfie];
            
            self.isOpenImage.image = [self.isOpenImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [self.isOpenImage setTintColor:[UIColor greenHairfie]];
        }
        else {
            if ([business.kind isEqualToString:KIND_ATHOME]) {
                self.isOpenLabel.text = NSLocalizedStringFromTable(@"Does not work today", @"Salon_Detail", nil);
            } else {
                self.isOpenLabel.text = NSLocalizedStringFromTable(@"Closed today", @"Salon_Detail", nil);
            }
            self.isOpenImageDetail.hidden = YES;
        }
    }
    
    if ([business.numReviews isEqualToNumber:@0]) {
        [self.reviewsSectionHeight setConstant:0];
    } else {
        NSInteger tes = MIN(NUM_REVIEWS, [business.numReviews integerValue]);
        
        [self.reviewsSectionHeight setConstant:(REVIEW_ROW_HEIGHT * tes + 70)];

        [_moreReviewBttn setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"more (%@)", @"Salon_Detail", nil), business.numReviews]
                         forState:UIControlStateNormal];
    }
  }

-(IBAction)showTimeTable:(id)sender
{
    if (self.isOpenLabelDetail.hidden == NO) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTimetable" object:nil];
    }
}

-(IBAction)showMapFromSalon:(id)sender
{
 [[NSNotificationCenter defaultCenter] postNotificationName:@"showBusinessMap" object:nil];
}

-(void)setupReviews
{
    if ([business.numReviews isEqualToNumber:@0]) {
        loadingReviews = NO;
        return;
    }
    
    if (loadingReviews) {
        return;
    }
    
    loadingReviews = YES;
    
    [BusinessReview listLatestByBusiness:business.id
                                   limit:[NSNumber numberWithInt:NUM_REVIEWS]
                                    skip:@0
                                 success:^(NSArray *loadedReviews) {
                                     reviews = loadedReviews;
                                     loadingReviews = NO;
                                     [self.reviewTableView reloadData];
                                 }
                                 failure:^(NSError *error) {
                                     NSLog(@"Failed to load last reviews: %@", error.localizedDescription);
                                     loadingReviews = NO;
                                 }];
}

-(void)setupCrossSell
{
    if (!business.crossSell) {
        [self.similarTableView setHidden:YES];
        [self.similarBusinessesLbl setHidden:YES];
        return;
    };
    
    [Business listSimilarTo:business.id
                      limit:[NSNumber numberWithInt:NUM_SIMILAR_BUSINESSES]
                    success:^(NSArray *businesses) {
                        similarBusinesses = businesses;
                        [self.similarTableView reloadData];
                    }
                    failure:^(NSError *error) {
                        NSLog(@"%@", error.localizedDescription);
                    }];
}

-(void)addPhoneNumbersToView
{
    self.telephoneBg.hidden = YES;
    self.telephone.hidden = YES;
    UIButton *phoneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    phoneBtn.frame= CGRectMake(35, 85, 135, 20);
    phoneBtn.backgroundColor = [UIColor colorWithRed:250/255.0f green:93/255.0f blue:100/255.0f alpha:1];
    phoneBtn.layer.cornerRadius = 5;
    phoneBtn.layer.masksToBounds = YES;
    
    NSString *phoneBttnTitle = [[NSString alloc] init];
    
    phoneBttnTitle = [phoneBttnTitle formatPhoneNumber:business.phoneNumber];
    
    [phoneBtn setTitle:phoneBttnTitle forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];
    [phoneBtn addTarget:self action:@selector(didClickOnCallButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneBtn];
}

-(IBAction)didClickOnCallButton:(id)sender
{
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", business.phoneNumber]]];
}

-(IBAction)showReviews:(id)sender
{
    if (appDelegate.currentUser) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showReviews" object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoUserConnected" object:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.reviewTableView) {
        return reviews.count;
    } else if (tableView == self.similarTableView) {
        return similarBusinesses.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.reviewTableView) {
        return REVIEW_ROW_HEIGHT;
    } else if (tableView == self.similarTableView) {
        return 110;
    } else {
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.reviewTableView) {
        static NSString *CellIdentifier = @"reviewCell";
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.review = reviews[indexPath.row];
        
        return cell;
    } else if (tableView == self.similarTableView) {
        static NSString *CellIdentifier = @"similarCell";
        SimilarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimilarTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.business = similarBusinesses[indexPath.row];
        cell.locationForDistance = business.gps;
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.similarTableView) {
        
        NSDictionary* userInfo = @{@"similarPicked": similarBusinesses[indexPath.row]};
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"similarBusinessPicked" object:self userInfo:userInfo];
        
        [self.similarTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
