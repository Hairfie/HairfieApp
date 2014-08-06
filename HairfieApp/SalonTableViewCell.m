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
@synthesize name = _name,
hairfieNb = _hairfieNb,
womanPrice = _womanPrice,
manPrice = _manPrice,
currentSales = _currentSales,
bookButton = _bookButton,
ratingLabel = _ratingLabel,
salonRating = _salonRating,
statusLabelView = _statusLabelView,
salonPicture = _salonPicture,
imgUrl = _imgUrl,
nbReviews = _nbReviews;

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
    
    _salonRating.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _salonRating.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _salonRating.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    
    _salonRating.editable = NO;
    _salonRating.maxRating = 5;
    _salonRating.delegate = self;
}

- (void) customInit:(NSDictionary*)salon
{
    
    NSDictionary *price = [salon objectForKey:@"price"];
    NSDictionary *review = [salon objectForKey:@"reviews"];
    NSString *imgUrl = [salon objectForKey:@"gps_picture"];

    _name.text = [salon objectForKey:@"name"];
    _manPrice.text = [NSString stringWithFormat:@"%@ €",[[price objectForKey:@"men"] stringValue]];
    _womanPrice.text = [NSString stringWithFormat:@"%@ €",[[price objectForKey:@"women"] stringValue]];
    _salonPicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
    _salonPicture.contentMode = UIViewContentModeScaleAspectFill;
   
    if ([[review objectForKey:@"total"] integerValue] == 0)
    {
        _salonRating.rating = 0;
        _ratingLabel.text = @"0";
        _nbReviews.text = @"- 0 review";
    }
    else
    {
        _salonRating.rating = [[review objectForKey:@"average"] floatValue];
        _ratingLabel.text = [[review objectForKey:@"average"] stringValue];
        _nbReviews.text =[NSString stringWithFormat:@"- %@ reviews",[review objectForKey:@"total"]];
    }
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
 //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
