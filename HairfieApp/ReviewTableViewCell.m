//
//  ReviewTableViewCell.m
//  HairfieApp
//
//  Created by Leo Martin on 05/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import "BusinessReview.h"
#import "User.h"

@interface ReviewTableViewCell ()

@end

@implementation ReviewTableViewCell

@synthesize ratingView = _ratingView, nameLabel = _nameLabel, contentLabel = _contentLabel, statusLabel = _statusLabel, postDate = _postDate;

- (void)awakeFromNib {
    
    
    profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 41, 41)];
    
    // mettre viariable photo salon ici
    profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2;
    profilePicture.clipsToBounds = YES;
    profilePicture.layer.borderWidth = 1.0f;
    profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    profilePicture.image = [UIImage imageNamed:@"leosquare.jpg"];
    [self.viewForBaselineLayout addSubview:profilePicture];
    _ratingView.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _ratingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _ratingView.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    _ratingView.rating = 3;
    _ratingView.editable = NO;
    _ratingView.maxRating = 5;
    _ratingView.delegate = self;
    _statusLabel.text = [NSString stringWithFormat:@"3"];
    _postDate.text = [NSString stringWithFormat:@"-  %@", @"Juillet 2014"];
    
    

}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}


-(void)setReview:(BusinessReview*)review
{
    
   // NSLog(@"author review %@", review.author.class);
    
    _contentLabel.text = review.comment;
    _ratingView.rating = [review.rating floatValue];
    _nameLabel.text = review.author.displayName;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
