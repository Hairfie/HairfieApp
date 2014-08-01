//
//  SalonTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 01/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SalonTableViewCell.h"
#import "EDStarRating.h"

@implementation SalonTableViewCell

@synthesize name = _name, hairfieNb = _hairfieNb, womanPrice = _womanPrice, manPrice = _manPrice, hairfieDescription = _hairfieDescription ,currentSales = _currentSales, bookButton = _bookButton, starRating = _starRating;

- (void)awakeFromNib {
    // Initialization code
    _bookButton.text = [NSString stringWithFormat:NSLocalizedString(@"book", nil)];
    _starRating.backgroundColor  = [UIColor whiteColor];
    _starRating.starImage = [[UIImage imageNamed:@"selected-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.starHighlightedImage = [[UIImage imageNamed:@"star-highlighted-template"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _starRating.maxRating = 5.0;
    _starRating.delegate = self;
    _starRating.horizontalMargin = 20;
    _starRating.editable= NO;
    _starRating.rating= 5; // mettre variable qui change
    _starRating.displayMode=EDStarRatingDisplayHalf;
    [_starRating  setNeedsDisplay];
    _starRating.tintColor = [UIColor redColor];
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    NSString *ratingString = [NSString stringWithFormat:@"Rating: %.1f", rating];
    _starRatingLabel.text = ratingString;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
