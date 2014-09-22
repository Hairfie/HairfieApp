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


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupHeaderView];
    [self getReviews];
    [self setupReviewRating];
    
    _addReviewButton.layer.cornerRadius = 5;
    _addReviewButton.layer.masksToBounds = YES;
    _reviewTableView.backgroundColor = [UIColor whiteColor];
   // _dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    // Do any additional setup after loading the view.
}


-(void)getReviews
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results){
        reviews = results;
        [_reviewTableView reloadData];
       if (_isReviewing == YES)
        [_reviewTextView becomeFirstResponder];
    };
    
    [BusinessReview listLatestByBusiness:_business.id limit:@20 skip:@0 success:loadSuccessBlock failure:loadErrorBlock];
}


- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    _isReviewing = YES;
    [_reviewTableView reloadData];
     [_reviewTextView becomeFirstResponder];
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
    _isReviewing = YES;
    if ([_reviewTextView.text isEqualToString:@""] || [_reviewTextView.text isEqualToString:@"Ajoutez votre review..."])
    {
        _reviewTextView.text = @"Ajoutez votre review...";
        // need feedback no text in review = no review
        [_reviewTableView reloadData];
        [_reviewTextView becomeFirstResponder];
    }
    else
    {
        if (_isReviewing == YES)
        {
            [self saveReview];
            [self getReviews];
        }
        else
            NSLog(@"test");
        
    }
}

-(void) saveReview
{
    

    [_reviewTextView resignFirstResponder];
    NSNumber *reviewValue = [NSNumber numberWithFloat:_reviewRating.rating];
    
    NSDictionary *businessDic = [_business toDictionary];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:reviewValue, @"rating", _reviewTextView.text, @"comment", businessDic, @"business",nil];
  
    BusinessReview *review = [[BusinessReview alloc] initWithDictionary:dic];
  
    [review save];
    _isReviewing = NO;
    _reviewRating.rating = 0;
    _reviewTextView.text = @"";
   
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


// Text View Delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    [textView becomeFirstResponder];
//    [self.view addGestureRecognizer:_dismiss];

}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (BOOL) textView: (UITextView*) textView
shouldChangeTextInRange: (NSRange) range
  replacementText: (NSString*) text
{
    if ([text isEqualToString:@"\n"]) {

        _isReviewing = NO;
        
        if ([_reviewTextView.text isEqualToString:@""] || [_reviewTextView.text isEqualToString:NSLocalizedStringFromTable(@"Ajoutez votre review...", @"Salon_Detail", nil)])
        {
            _reviewTextView.text = NSLocalizedStringFromTable(@"Ajoutez votre review...", @"Salon_Detail", nil);
            [_reviewTextView resignFirstResponder];
            [_reviewTableView reloadData];
        }
        else{
            [self saveReview];
            [self getReviews];
        }

        return NO;
    }
    return YES;
}


-(void) setupHeaderView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, _reviewHeight)];
    _bgView.backgroundColor = [UIColor whiteColor];


    UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 196)];

    _reviewTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, 280, 176)];
    _reviewTextView.delegate = self;
    _reviewTextView.backgroundColor = [UIColor clearColor];
    _reviewTextView.text = NSLocalizedStringFromTable(@"Add a review", @"Salon_Detail", nil);
    _reviewTextView.textColor = [[UIColor blackHairfie] colorWithAlphaComponent:0.6];
    _reviewTextView.returnKeyType = UIReturnKeyDone;


    frontView.backgroundColor = [UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:0.1];
    frontView.layer.cornerRadius = 5;
    frontView.layer.masksToBounds = YES;

    [_bgView addSubview:frontView];

    [frontView addSubview:_reviewTextView];

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
