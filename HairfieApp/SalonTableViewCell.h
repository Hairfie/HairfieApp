//
//  SalonTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 01/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"


@interface SalonTableViewCell : UITableViewCell <RatingViewDelegate>


@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *hairfieNb;
@property (nonatomic) IBOutlet UILabel *location;
@property (nonatomic) IBOutlet UILabel *hairfieDescription;
@property (nonatomic) IBOutlet UILabel *manPrice;
@property (nonatomic) IBOutlet UILabel *womanPrice;
@property (nonatomic) IBOutlet UILabel *currentSales;
@property (nonatomic) IBOutlet UILabel *bookButton;
@property (nonatomic) IBOutlet UIImageView *salonPicture;

@property (weak, nonatomic) IBOutlet RatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIView *statusLabelView;

@end
