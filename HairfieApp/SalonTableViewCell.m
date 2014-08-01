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
@synthesize name = _name, hairfieNb = _hairfieNb, womanPrice = _womanPrice, manPrice = _manPrice, hairfieDescription = _hairfieDescription ,currentSales = _currentSales, bookButton = _bookButton, ratingView = _ratingView, statusLabel = _statusLabel, statusLabelView = _statusLabelView, salonPicture = _salonPicture, imgUrl = _imgUrl;

- (void)awakeFromNib {
    // Initialization code
    
    profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 41, 41)];
    
    // mettre viariable photo salon ici
    NSLog(@"test img name in cell : %@", _imgUrl);
    [self customInit];
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.viewForBaselineLayout addSubview:profilePicture];
    
    
    _bookButton.text = [NSString stringWithFormat:NSLocalizedString(@"book", nil)];
   
    _statusLabelView.layer.cornerRadius = 5;
    _statusLabelView.layer.masksToBounds = YES;
    
    _ratingView.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _ratingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _ratingView.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    _ratingView.rating = 3;
    _ratingView.editable = NO;
    _ratingView.maxRating = 5;
    _ratingView.delegate = self;
    _statusLabel.text = [NSString stringWithFormat:@"3"];
    
}

- (void) customInit {

    
    profilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imgUrl]]];
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
 //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
