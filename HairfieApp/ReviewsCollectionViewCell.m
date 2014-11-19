//
//  ReviewsCollectionViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 11/19/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ReviewsCollectionViewCell.h"
#import "User.h"
#import "UIRoundImageView.h"

@implementation ReviewsCollectionViewCell

- (void)awakeFromNib {
  
    
    profilePicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(10, 9, 41, 41)];
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    [profilePicture setBackgroundColor:[UIColor lightGreyHairfie]];
    [self.viewForBaselineLayout addSubview:profilePicture];
    _ratingView.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _ratingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _ratingView.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    _ratingView.rating = 3;
    _ratingView.editable = NO;
    _ratingView.maxRating = 5;
    _ratingView.delegate = self;
    _statusLabel.text = [NSString stringWithFormat:@"3"];
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}


-(void)setReview:(BusinessReview*)review
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc ]init];
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    _postDate.text = [dateFormatter stringFromDate:review.createdAt];
    _contentLabel.text = review.comment;
    _ratingView.rating = [[review ratingBetween:@0 and:@5] floatValue];
    _statusLabel.text = [[review ratingBetween:@0 and:@5] stringValue];
    _nameLabel.text = review.author.displayName;
    
    [profilePicture sd_setImageWithURL:[review.author pictureUrlwithWidth:@100 andHeight:@100]
                      placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
}

@end
