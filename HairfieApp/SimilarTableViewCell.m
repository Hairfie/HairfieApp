//
//  SimilarTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 05/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SimilarTableViewCell.h"

@implementation SimilarTableViewCell

- (void)awakeFromNib {
    
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

    _statusLabel.text = [NSString stringWithFormat:@"- donnez votre avis !"];

    _salonPicture.image = [UIImage imageNamed:@"placeholder-image.jpg"];
    // Initialization code
}

- (void) customInit:(NSDictionary*)salon
{
    NSString *imgUrl = [salon objectForKey:@"gps_picture"];
    _name.text = [salon objectForKey:@"name"];
    _salonPicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
    _salonPicture.contentMode = UIViewContentModeScaleAspectFill;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}

@end
