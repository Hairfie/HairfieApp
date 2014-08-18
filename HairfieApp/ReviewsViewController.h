//
//  ReviewsViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface ReviewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,RatingViewDelegate>

@property (strong, nonatomic) IBOutlet RatingView *reviewRating;
@property (nonatomic) IBOutlet UITableView *reviewTableView;

-(IBAction)goBack:(id)sender;



@end
