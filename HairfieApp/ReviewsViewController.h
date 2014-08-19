//
//  ReviewsViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface ReviewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,RatingViewDelegate, UITextViewDelegate>


@property (nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic) NSInteger ratingValue;
@property (nonatomic) BOOL isReviewing;
@property (nonatomic) IBOutlet UIButton *addReviewButton;
@property (nonatomic) NSInteger reviewHeight;

// table header

@property (nonatomic)  UIView *bgView;
@property (nonatomic)  UIView *whiteBg;
@property (strong, nonatomic) IBOutlet RatingView *reviewRating;
@property (nonatomic,strong)  UITextView *reviewTextView;

-(IBAction)addReview:(id)sender;


@property (nonatomic) UITextView *reviewField;
@property (nonatomic) UITapGestureRecognizer *dismiss;

-(IBAction)goBack:(id)sender;



@end
