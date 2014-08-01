//
//  RatingView.h
//  HairfieApp
//
//  Created by Leo Martin on 01/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RatingView;

@protocol RatingViewDelegate
- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating;
@end

@interface RatingView : UIView

@property (strong, nonatomic) UIImage *notSelectedImage;
@property (strong, nonatomic) UIImage *halfSelectedImage;
@property (strong, nonatomic) UIImage *fullSelectedImage;
@property (assign, nonatomic) float rating;
@property (assign) BOOL editable;
@property (strong) NSMutableArray * imageViews;
@property (assign, nonatomic) int maxRating;
@property (assign) int midMargin;
@property (assign) int leftMargin;
@property (assign) CGSize minImageSize;
@property (assign) id <RatingViewDelegate> delegate;

@end