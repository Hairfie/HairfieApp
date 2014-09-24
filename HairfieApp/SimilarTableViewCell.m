//
//  SimilarTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 05/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SimilarTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"

@implementation SimilarTableViewCell
{
    GeoPoint *currentLocation;
}

-(void)awakeFromNib
{
    _salonPicture.layer.cornerRadius = 5;
    _salonPicture.layer.masksToBounds = YES;
    
    _bookButton.layer.cornerRadius = 5;
    _bookButton.layer.masksToBounds = YES;
    
   // _salonPicture.image = [UIImage imageNamed:@"leosquare.jpg"];
    
    _ratingView.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _ratingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _ratingView.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    _ratingView.rating = 0;
    _ratingView.editable = NO;
    _ratingView.maxRating = 5;
    _ratingView.delegate = self;

    _statusLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"- rate this hairdresser !", @"Salon_Detail", nil)];

    _salonPicture.image = [UIImage imageNamed:@"placeholder-image.jpg"];
    // Initialization code
}

-(void)customInit:(Business *)business
{
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:business.thumbnail]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                          if (image && finished) {
                                                              self.salonPicture.image = image;
                                                          }
                                                      }];
    
    self.name.text = business.name;
    self.ratingView.rating = [[business ratingBetween:@0 and:@5] floatValue];
    self.numHairfiesLabel.text = business.displayNumHairfies;

    GeoPoint *currentLocation = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentLocation];
    
    if (currentLocation == nil) {
        self.location.hidden = YES;
    } else {
        self.location.text = [NSString stringWithFormat:@"%.1f km", [[business distanceTo:currentLocation] floatValue] / 1000];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}

@end
