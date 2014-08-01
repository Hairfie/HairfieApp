//
//  SalonTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 01/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SalonTableViewCell.h"


@implementation SalonTableViewCell

@synthesize name = _name, hairfieNb = _hairfieNb, womanPrice = _womanPrice, manPrice = _manPrice, hairfieDescription = _hairfieDescription ,currentSales = _currentSales, bookButton = _bookButton, ratingView = _ratingView, statusLabel = _statusLabel;

- (void)awakeFromNib {
    // Initialization code
    _bookButton.text = [NSString stringWithFormat:NSLocalizedString(@"book", nil)];

    _ratingView.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _ratingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _ratingView.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    _ratingView.rating = 3;
    _ratingView.editable = NO;
    _ratingView.maxRating = 5;
    _ratingView.delegate = self;
    _statusLabel.text = [NSString stringWithFormat:@"3"];
    
}
/*
- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
