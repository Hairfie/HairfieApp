//
//  SalonTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 01/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import <LoopBack/LoopBack.h>


@interface SalonTableViewCell : UITableViewCell <RatingViewDelegate>


@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *hairfieNb;
@property (nonatomic) IBOutlet UILabel *location;
@property (nonatomic) IBOutlet UILabel *manPrice;
@property (nonatomic) IBOutlet UILabel *womanPrice;
@property (nonatomic) IBOutlet UILabel *currentSales;
@property (nonatomic) IBOutlet UIButton *bookButton;
@property (nonatomic) IBOutlet UIImageView *salonPicture;
@property (nonatomic) NSString *imgUrl;

@property (weak, nonatomic) IBOutlet RatingView *salonRating;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nbReviews;
@property (weak, nonatomic) IBOutlet UIView *statusLabelView;

- (void) customInit:(LBModel*)model;

@end
