//
//  ReviewsViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SAMTextView/SAMTextView.h>
#import "RatingView.h"
#import "Business.h"

@interface ReviewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic) IBOutlet UIView *topBarView;
@property (nonatomic) Business *business;

-(IBAction)goBack:(id)sender;

@end
