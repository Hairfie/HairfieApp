//
//  ReviewsCollectionViewCell.h
//  HairfieApp
//
//  Created by Leo Martin on 11/19/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
#import "BusinessReview.h"

@interface ReviewsCollectionViewCell : UICollectionViewCell <RatingViewDelegate>
{
    UIImageView *profilePicture;
}
@property (weak, nonatomic) IBOutlet RatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDate;

-(void)setReview:(BusinessReview*)review;

@end
