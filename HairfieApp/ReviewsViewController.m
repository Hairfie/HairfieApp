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

@interface ReviewsViewController ()

@end

@implementation ReviewsViewController
{
    NSArray *reviews;
}
@synthesize reviewRating = _reviewRating, ratingValue = _ratingValue, dismiss = _dismiss, addReviewButton = _addReviewButton;


-(void)viewDidLoad
{
    [super viewDidLoad];
   
    [self setupHeaderView];
    [self getReviews];
    [self setupReviewRating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshReviews:)
                                                 name:@"reviewSaved"
                                               object:nil];

    self.addReviewButton.layer.cornerRadius = 5;
    self.addReviewButton.layer.masksToBounds = YES;
    
    if(_ratingValue > 0) {
        self.addReviewButton.hidden = NO;
    } else {
        self.addReviewButton.hidden = YES;
    }

    self.reviewTableView.backgroundColor = [UIColor whiteColor];
    
    _reviewTextView.placeholder = NSLocalizedStringFromTable(@"Ajoutez votre review...", @"Salon_Detail", nil);
}


-(void)refreshReviews:(NSNotification*) notification
{
    NSLog(@"==============RESFRESH NOTIFICATION");
    [self getReviews];
}

-(void)getReviews
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results){
        reviews = results;
        if (reviews.count == 0)
            _reviewTableView.separatorColor = [UIColor clearColor];
        else
            _reviewTableView.separatorColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1];
        [_reviewTableView reloadData];
       if (_isReviewing == YES)
        [_reviewTextView becomeFirstResponder];
    };
    
    [BusinessReview listLatestByBusiness:_business.id limit:@20 skip:@0 success:loadSuccessBlock failure:loadErrorBlock];
}


- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating
{
//    if ([_reviewTextView.text isEqualToString:NSLocalizedStringFromTable(@"Ajoutez votre review...", @"Salon_Detail", nil)])
//        _reviewTextView.text = @"";
    if (![_reviewTextView isFirstResponder]) {
        NSLog(@"test");
        [_reviewTextView becomeFirstResponder];
        _addReviewButton.hidden = NO;
    }
    _isReviewing = YES;
     [_reviewTableView reloadData];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) hideKeyboard
{
    [_reviewTextView resignFirstResponder];
    _isReviewing = NO;
    _reviewRating.rating = 0;

    [_reviewTableView reloadData];
}

-(IBAction)addReview:(id)sender
{
    if ([self.reviewTextView.text isEqualToString:@""]) {
        self.isReviewing = NO;
        self.addReviewButton.hidden = YES;
        self.reviewRating.rating = 0;
        [self.reviewTableView reloadData];
        [self.reviewTextView becomeFirstResponder];
    } else {
        [self saveReview];
    }
}

-(void)saveReview
{
    [self.reviewTextView resignFirstResponder];

    BusinessReview *review = [[BusinessReview alloc] init];
    review.business = self.business;
    [review setRating:[NSNumber numberWithFloat:self.reviewRating.rating] between:@0 and:@5];
    review.comment = self.reviewTextView.text;
    [review save];

    self.isReviewing = NO;
    self.addReviewButton.hidden = YES;
    self.reviewRating.rating = 0;
    self.reviewTextView.text = @"";
}


-(void)setupReviewRating
{
    _reviewRating.backgroundColor = [UIColor clearColor];
    _reviewRating.notSelectedImage = [UIImage imageNamed:@"not_selected_review.png"];
    _reviewRating.halfSelectedImage = [UIImage imageNamed:@"half_selected_review.png"];
    _reviewRating.fullSelectedImage = [UIImage imageNamed:@"selected_review.png"];
    _reviewRating.rating = _ratingValue;
    _reviewRating.editable = YES;
    _reviewRating.maxRating = 5;
    _reviewRating.delegate = self;
}




-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.reviewTextView.text isEqualToString:@""]) {
            self.reviewRating.rating = 0;
            self.isReviewing = NO;
            _addReviewButton.hidden = YES;
            [_reviewTextView resignFirstResponder];
            [_reviewTableView reloadData];
        }
        else
        {
            
            [self saveReview];
            
        }

        return NO;
    }
    return YES;
}

-(BOOL)textViewShouldReturn:(UITextView *)textView
{
    if ([_reviewTextView.text isEqualToString:@""]) {
        self.reviewRating.rating = 0;
        self.addReviewButton.hidden = YES;
        self.isReviewing = NO;
        [self.reviewTextView resignFirstResponder];
        [self.reviewTableView reloadData];
    }
    else
    {
        
        [self saveReview];
        
    }
    
    return YES;
}


-(void) setupHeaderView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, _reviewHeight)];
    _bgView.backgroundColor = [UIColor whiteColor];


    UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 196)];

    self.reviewTextView = [[SAMTextView alloc] initWithFrame:CGRectMake(20, 10, 280, 176)];
    self.reviewTextView.delegate = self;
    self.reviewTextView.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14];
    self.reviewTextView.backgroundColor = [UIColor clearColor];
    self.reviewTextView.textColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.6];
    self.reviewTextView.returnKeyType = UIReturnKeyDone;
    self.reviewTextView.placeholder = NSLocalizedStringFromTable(@"Enter a comment...", @"Salon_Detail", nil);


    frontView.backgroundColor = [UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:0.1];
    frontView.layer.cornerRadius = 5;
    frontView.layer.masksToBounds = YES;

    [_bgView addSubview:frontView];

    [frontView addSubview:self.reviewTextView];

}


// Table View Delegate/Datasource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _bgView;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isReviewing)
        return 210;
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

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

    [cell setReview:review];
    return cell;
}

@end
