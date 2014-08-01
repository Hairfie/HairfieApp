//
//  SalonTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 01/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface SalonTableViewCell : UITableViewCell <EDStarRatingProtocol>


@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *hairfieNb;
@property (nonatomic) IBOutlet UILabel *location;
@property (nonatomic) IBOutlet UILabel *hairfieDescription;
@property (nonatomic) IBOutlet UILabel *manPrice;
@property (nonatomic) IBOutlet UILabel *womanPrice;
@property (nonatomic) IBOutlet UILabel *currentSales;
@property (nonatomic) IBOutlet UILabel *bookButton;
@property (nonatomic) IBOutlet UIImageView *salonPicture;

@property (weak, nonatomic) IBOutlet EDStarRating *starRating;
@property (weak, nonatomic) IBOutlet UILabel *starRatingLabel;


@end
