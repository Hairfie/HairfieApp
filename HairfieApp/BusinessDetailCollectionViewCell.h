//
//  BusinessDetailCollectionViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"
#import "RatingView.h"

@interface BusinessDetailCollectionViewCell : UICollectionViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UILabel *address;
@property (nonatomic) IBOutlet UILabel *city;
@property (nonatomic) IBOutlet UILabel *telephone;
@property (nonatomic) IBOutlet UIView *telephoneBg;
@property (nonatomic) IBOutlet UILabel *isOpenLabel;
@property (nonatomic) IBOutlet UILabel *isOpenLabelDetail;
@property (nonatomic) IBOutlet UIImageView *isOpenImage;
@property (nonatomic) IBOutlet UIImageView *isOpenImageDetail;
@property (nonatomic) IBOutlet UITableView *similarTableView;
@property (nonatomic) IBOutlet UIView *similarContainerView;
@property (nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic) IBOutlet UIButton *moreReviewBttn;
@property (nonatomic) IBOutlet UIView *reviewsSection;
@property (nonatomic) IBOutlet UILabel *seeDetailsLbl;
@property (nonatomic) IBOutlet UILabel *similarBusinessesLbl;
@property (nonatomic) IBOutlet NSLayoutConstraint *telephoneLabelWidth;
@property (nonatomic) IBOutlet NSLayoutConstraint *reviewsListHeight;
@property (nonatomic) IBOutlet NSLayoutConstraint *reviewsSectionHeight;

-(void)setupDetails:(Business*)business;

@end
