//
//  BusinessDetailCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessDetailCollectionViewCell.h"
#import "NSString+PhoneFormatter.h"
#import "ReviewTableViewCell.h"
#import "SimilarTableViewCell.h"
#import "BusinessReview.h"

@implementation BusinessDetailCollectionViewCell
{
     BOOL loadingLastestReviews;
    NSArray *latestReviews;
    NSArray *similarBusinesses;
    Business *business;
}
- (void)awakeFromNib {
    // Initialization code
}


-(void)setupDetails:(Business*)aBusiness
{
    business = aBusiness;
    
    self.reviewTableView.delegate = self;
    self.reviewTableView.dataSource = self;
    self.similarTableView.delegate = self;
    self.similarTableView.dataSource = self;
    self.moreReviewBttn.layer.cornerRadius = 5;
    [self setupCrossSell];
    [self setupRecentReviews];
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
    
    self.addRatingSuperView.layer.cornerRadius = 5;
    self.addRatingView.notSelectedImage = [UIImage imageNamed:@"not_selected_review.png"];
    self.addRatingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_review.png"];
    self.addRatingView.fullSelectedImage = [UIImage imageNamed:@"selected_review.png"];
    self.addRatingView.rating = 0;
    self.addRatingView.editable = YES;
    self.addRatingView.maxRating = 5;
    self.addRatingView.delegate = self;
    
    if ([business.numReviews isEqualToNumber:@0]) {
        // hide reviews list
        self.reviewTableView.hidden = YES;
        self.moreReviewBttn.hidden = YES;
        self.moreReviewButtonYpos.constant = 288;
    } else {
        
        
        NSInteger tes = MIN(2, [business.numReviews integerValue]);
        self.reviewTableView.hidden = NO;
        self.moreReviewButtonYpos.constant = 308 + (130 * tes);
       // self.similarViewYPos.constant = self.moreReviewButtonYpos.constant + 30;
        [_moreReviewBttn setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"more (%@)", @"Salon_Detail", nil), business.numReviews]
                         forState:UIControlStateNormal];
    }

    
    
//    self.pricesView.hidden = YES;
//    
//    self.salonRating.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
//    _salonRating.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
//    _salonRating.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
//    _salonRating.editable = NO;
//    _salonRating.maxRating = 5;
//    _salonRating.delegate = self;
//    _salonRating.rating = [[business ratingBetween:@0 and: @5] floatValue];
//    
   //
  }

-(void)setupRecentReviews
{
    if ([business.numReviews isEqualToNumber:@0]) {
        loadingLastestReviews = NO;
        return;
    }
    
    if (loadingLastestReviews) {
        return;
    }
    
    loadingLastestReviews = YES;
    
    [BusinessReview listLatestByBusiness:business.id
                                   limit:@2
                                    skip:@0
                                 success:^(NSArray *reviews) {
                                     latestReviews = reviews;
                                     loadingLastestReviews = NO;
                                     [self.reviewTableView reloadData];
                                 }
                                 failure:^(NSError *error) {
                                     NSLog(@"Failed to load last reviews: %@", error.localizedDescription);
                                     loadingLastestReviews = NO;
                                 }];
}

-(void)setupCrossSell
{
    if (!business.crossSell) return;
    
    [Business listSimilarTo:business.id
                      limit:@3
                    success:^(NSArray *businesses) {
                        similarBusinesses = businesses;
                        [self.similarTableView reloadData];
                    }
                    failure:^(NSError *error) {
                        NSLog(@"%@", error.localizedDescription);
                    }];
}

-(void)rateView:(RatingView *)rateView ratingDidChange:(float)rating
{

}

-(void)addPhoneNumbersToView
{
    self.telephoneBg.hidden = YES;
    self.telephone.hidden = YES;
    UIButton *phoneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    phoneBtn.frame= CGRectMake(35, 85, 135, 20);
    phoneBtn.backgroundColor = [UIColor colorWithRed:250/255.0f green:66/255.0f blue:77/255.0f alpha:1];
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
    NSLog(@"CALL");
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.reviewTableView) {
        return latestReviews.count;
    } else if (tableView == self.similarTableView) {
        return similarBusinesses.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.reviewTableView)
        return 130;
    else if (tableView == self.similarTableView)
        return 110;
    else
        return 90;
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
        
        cell.review = latestReviews[indexPath.row];
        
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
        //[self performSegueWithIdentifier:@"similarBusiness" sender:self.similarBusinesses[indexPath.row]];
    }
    
}

@end
