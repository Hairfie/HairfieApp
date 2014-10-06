//
//  SimilarTableViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 05/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import <LoopBack/LoopBack.h>
#import "Business.h"
#import "GeoPoint.h"

@interface SimilarTableViewCell : UITableViewCell <RatingViewDelegate>


@property (weak, nonatomic) IBOutlet RatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UILabel *location;
@property (nonatomic) IBOutlet UIImageView *locationPinImage;
@property (nonatomic) IBOutlet UIImageView *salonPicture;
@property (nonatomic) IBOutlet UIButton *bookButton;
@property (weak, nonatomic) IBOutlet UILabel *numHairfiesLabel;
@property (weak, nonatomic) Business *business;
@property (weak, nonatomic) GeoPoint *locationForDistance;

-(void)customInit:(Business* )business;

@end
