//
//  ReviewsViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ReviewsViewController.h"
#import "ReviewTableViewCell.h"
#import "BusinessReview.h"
#import "HairfieNotifications.h"

@implementation ReviewsViewController
{
    NSArray *reviews;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadReviews];
    
    self.reviewTableView.backgroundColor = [UIColor whiteColor];
}

-(void)loadReviews
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results){
        reviews = results;
        if (reviews.count == 0) {
            self.reviewTableView.separatorColor = [UIColor clearColor];
        } else {
            self.reviewTableView.separatorColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1];
        }
        [self.reviewTableView reloadData];
    };
    
    [BusinessReview listLatestByBusiness:_business.id limit:@20 skip:@0 success:loadSuccessBlock failure:loadErrorBlock];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Table View Delegate/Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [reviews count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"reviewCell";
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BusinessReview *review = (BusinessReview *)[reviews objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.review = review;

    return cell;
}

@end