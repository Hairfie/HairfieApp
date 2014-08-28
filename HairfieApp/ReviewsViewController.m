//
//  ReviewsViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 18/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "ReviewsViewController.h"
#import "ReviewTableViewCell.h"

@interface ReviewsViewController ()

@end

@implementation ReviewsViewController

@synthesize reviewRating = _reviewRating, ratingValue = _ratingValue, dismiss = _dismiss, addReviewButton = _addReviewButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeaderView];
    [self setupReviewRating];
    _addReviewButton.layer.cornerRadius = 5;
    _addReviewButton.layer.masksToBounds = YES;
    _reviewTableView.backgroundColor = [UIColor whiteColor];
  // _reviewHeight = 70;
    _dismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    // Do any additional setup after loading the view.
}


-(void) viewWillAppear:(BOOL)animated
{
    [self setupHeaderView];
    if (_isReviewing == YES)
    {
         [_reviewTextView becomeFirstResponder];
        _reviewTableView.scrollEnabled = NO;
        _reviewTextView.text = @"";
               [_reviewTableView reloadData];
    }
    _reviewTableView.scrollEnabled = YES;
}


- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    _isReviewing = YES;
    _reviewTableView.scrollEnabled = NO;

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
    _reviewTableView.scrollEnabled = YES;
    _reviewRating.rating = 0;

    [_reviewTableView reloadData];
}

-(IBAction)addReview:(id)sender
{
    if (_isReviewing == NO)
    {
        _isReviewing = YES;

        _reviewTableView.scrollEnabled = NO;

    }
    [_reviewTableView reloadData];
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
    [self.view addGestureRecognizer:_dismiss];

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
        NSLog(@"JVIENS LA");

        _reviewTableView.scrollEnabled = YES;
        _reviewTextView.text = @"Ajoutez votre review...";
        _reviewRating.rating = 0;
        [_reviewTableView reloadData];
        [textView resignFirstResponder];

        return NO;
    }
   _reviewTableView.scrollEnabled = NO;
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        _isReviewing = YES;
        textView.text = @"Ajoutez votre review...";
        _reviewTableView.scrollEnabled = NO;
    }
    else
    {
        NSString *contentReview = textView.text;
        _isReviewing = NO;

        [_reviewTableView reloadData];
        _reviewTableView.scrollEnabled = YES;
    }

    [textView resignFirstResponder];
    [self.view removeGestureRecognizer:_dismiss];


}


-(void) setupHeaderView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, _reviewHeight)];
    _bgView.backgroundColor = [UIColor whiteColor];


    UIView *frontView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 196)];

    _reviewTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, 280, 176)];
    _reviewTextView.delegate = self;
    _reviewTextView.backgroundColor = [UIColor clearColor];
    _reviewTextView.text = @"Ajoutez votre review...";
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"reviewCell";
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor whiteColor];

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
