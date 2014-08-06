//
//  SalonTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 01/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SalonTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SalonTableViewCell
{
    UIImageView *profilePicture;
}
@synthesize name = _name, hairfieNb = _hairfieNb, womanPrice = _womanPrice, manPrice = _manPrice, hairfieDescription = _hairfieDescription ,currentSales = _currentSales, bookButton = _bookButton, ratingView = _ratingView, ratingLabel = _ratingLabel, statusLabelView = _statusLabelView, salonPicture = _salonPicture, imgUrl = _imgUrl;

- (void)awakeFromNib {
    // Initialization code
    
    // mettre viariable photo salon ici
    _salonPicture.layer.cornerRadius = 5;
    _salonPicture.layer.masksToBounds = YES;
    _bookButton.layer.cornerRadius = 5;
    _bookButton.layer.masksToBounds = YES;

    
    
  //  _bookButton.text = [NSString stringWithFormat:NSLocalizedString(@"book", nil)];
   
    _statusLabelView.layer.cornerRadius = 5;
    _statusLabelView.layer.masksToBounds = YES;
    
    _ratingView.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _ratingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _ratingView.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    
    _ratingView.editable = NO;
    _ratingView.maxRating = 5;
    _ratingView.delegate = self;
}

- (void) customInit:(NSDictionary*)salon
{
    
    NSDictionary *price = [salon objectForKey:@"price"];
    NSString *imgUrl = [salon objectForKey:@"gps_picture"];

    _name.text = [salon objectForKey:@"name"];
    _manPrice.text = [NSString stringWithFormat:@"%@ €",[[price objectForKey:@"men"] stringValue]];
    _womanPrice.text = [NSString stringWithFormat:@"%@ €",[[price objectForKey:@"women"] stringValue]];
    _salonPicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
    _ratingView.rating = [[salon objectForKey:@"average_review"] floatValue];
    _ratingLabel.text = [[salon objectForKey:@"average_review"] stringValue];
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
 //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
