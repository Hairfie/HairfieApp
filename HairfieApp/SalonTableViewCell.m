//
//  SalonTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 01/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SalonTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <LoopBack/LoopBack.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Business.h"

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
    
    _salonPicture.image = [UIImage imageNamed:@"placeholder-image.jpg"];
}

- (void) customInit:(Business *)business
{
    _name.text = business.name;
    _salonPicture.contentMode = UIViewContentModeScaleAspectFill;
    _location.text = [NSString stringWithFormat:@"%.1f km", [business.distance floatValue] / 1000];
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
 //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
