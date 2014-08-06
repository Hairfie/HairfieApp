//
//  SalonDetailViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 04/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SalonDetailViewController.h"
#import "ReviewTableViewCell.h"
#import "SimilarTableViewCell.h"

@interface SalonDetailViewController ()

@end

@implementation SalonDetailViewController

@synthesize imageSliderView =_imageSliderView, pageControl = _pageControl, infoView = _infoView, hairfieView = _hairfieView, hairdresserView = _hairdresserView, salesView = _salesView, infoBttn = _infoBttn, hairfieBttn = _hairfieBttn, hairdresserBttn = _hairdresserBttn, salesBttn = _salesBttn, reviewRating = _reviewRating, reviewTableView = _reviewTableView, addReviewBttn = _addReviewBttn, moreReviewBttn = _moreReviewBttn, similarTableView = _similarTableView, dataSalon = _dataSalon, ratingLabel = _ratingLabel, name = _name , womanPrice = _womanPrice, manPrice = _manPrice, salonRating = _salonRating, address = _address, city = _city, salonAvailability = _salonAvailability, nbReviews = _nbReviews;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initKnownData:_dataSalon];
    
    _imageSliderView.canCancelContentTouches = NO;
    
    _mainScrollView.contentSize = CGSizeMake(320, 1800);
    _reviewTableView.delegate = self;
    _reviewTableView.dataSource = self;
    _reviewTableView.userInteractionEnabled = NO;
    _reviewTableView.scrollEnabled = NO;
    _reviewTableView.backgroundColor = [UIColor clearColor];
    
    _similarTableView.delegate = self;
    _similarTableView.dataSource = self;
    _similarTableView.userInteractionEnabled = NO;
    _similarTableView.scrollEnabled = NO;
    _similarTableView.backgroundColor = [UIColor clearColor];
    
    _addReviewBttn.layer.cornerRadius = 5;
    _addReviewBttn.layer.masksToBounds = YES;
    
    _moreReviewBttn.layer.cornerRadius = 5;
    _moreReviewBttn.layer.masksToBounds = YES;
    
  // LOAD Pictures in page control (horizontal scroll view)

    NSArray *tutoArray = [[NSArray alloc] init];
    tutoArray = [[NSArray alloc] initWithObjects:@"settings-picto.png", @"business-picto.png", @"likes-picto.png", @"home-picto.png", @"favorites-picto.png", nil];
    _pageControl.numberOfPages = [tutoArray count];
    
    for (int i = 0; i < [tutoArray count]; i++) {
        CGRect frame;
        frame.origin.x = _imageSliderView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _imageSliderView.frame.size;
   
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
   
        
        imageView.image = [UIImage imageNamed:[tutoArray objectAtIndex:i]];
        imageView.contentMode = UIViewContentModeCenter;
        [_imageSliderView addSubview:imageView];
   }
    _imageSliderView.pagingEnabled = YES;
    _imageSliderView.contentSize = CGSizeMake(_imageSliderView.frame.size.width * [tutoArray count], _imageSliderView.frame.size.height);
    
    
    
    
    // Init Rating View
    
    _reviewRating.notSelectedImage = [UIImage imageNamed:@"not_selected_review.png"];
    _reviewRating.halfSelectedImage = [UIImage imageNamed:@"half_selected_review.png"];
    _reviewRating.fullSelectedImage = [UIImage imageNamed:@"selected_review.png"];
    _reviewRating.rating = 0;
    _reviewRating.editable = YES;
    _reviewRating.maxRating = 5;
    _reviewRating.delegate = self;
    
    
    // Do any additional setup after loading the view.
}


- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    //   _statusLabel.text = [NSString stringWithFormat:@"%.f", rating];
}


-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollview
{
    if (scrollview == _imageSliderView)
    {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollview.frame.size.width;
    int page = floor((scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    }
}


-(IBAction)changeTab:(id)sender
{
    NSLog(@"test");
    if(sender == _infoBttn)
        [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
    else if(sender == _hairfieBttn)
        [self setButtonSelected:_hairfieBttn andBringViewUpfront:_hairfieView];
    else if(sender == _hairdresserBttn)
        [self setButtonSelected:_hairdresserBttn andBringViewUpfront:_hairdresserView];
    else if(sender == _salesBttn)
         [self setButtonSelected:_salesBttn andBringViewUpfront:_salesView];
}
-(void)setButtonSelected:(UIButton*) button andBringViewUpfront:(UIView*) view
{
    [_tabView bringSubviewToFront:view];
    [self unSelectAll];
    [button setBackgroundColor:[UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:1]];
}

-(void) setNormalStateColor:(UIButton*) button
{
    [button setBackgroundColor:[UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:0.9]];
}

-(void) unSelectAll
{
    
    [self setNormalStateColor:_infoBttn];
    [self setNormalStateColor:_hairfieBttn];
    [self setNormalStateColor:_hairdresserBttn];
    [self setNormalStateColor:_salesBttn];
   /* _infoBttn.selected = NO;

    
    _hairfieBttn.selected = NO;
    _hairdresserBttn.selected = NO;
    _salesBttn.selected = NO;*/
}


-(IBAction)changePage:(id)sender {
    
    UIPageControl *pager = sender;
    NSLog(@"%ld", pager.currentPage);
    CGPoint offset = CGPointMake(pager.currentPage * _imageSliderView.frame.size.width, 0);
    [_imageSliderView setContentOffset:offset animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


// Table view delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _reviewTableView)
        return 130;
    else if (tableView == _similarTableView)
        return 100;
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (tableView == _reviewTableView)
    {
        static NSString *CellIdentifier = @"reviewCell";
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        return cell;

    }
    else if (tableView == _similarTableView)
    {
        static NSString *CellIdentifier = @"similarCell";
        SimilarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimilarTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    }
    return nil;
}

- (void) initKnownData:(NSDictionary*)salon
{
    NSDictionary *salonDetail = [salon objectForKey:@"obj"];
    NSDictionary *price = [salonDetail objectForKey:@"price"];
    NSArray *phoneNumber = [salonDetail objectForKey:@"phone_numbers"];
    NSDictionary *reviews = [salonDetail objectForKey:@"reviews"];
    
    if (phoneNumber == nil || [phoneNumber count] == 0)
        _telephone.text = [NSString stringWithFormat:@"No data"];
    else
        _telephone.text = [phoneNumber objectAtIndex:0];
    
    _name.text = [salonDetail objectForKey:@"name"];
    _manPrice.text = [NSString stringWithFormat:@"%@ €",[[price objectForKey:@"men"] stringValue]];
    _womanPrice.text = [NSString stringWithFormat:@"%@ €",[[price objectForKey:@"women"] stringValue]];
    _salonRating.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _salonRating.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _salonRating.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    _salonRating.editable = NO;
    _salonRating.maxRating = 5;
    _salonRating.delegate = self;
    
    if ([[reviews objectForKey:@"total"] integerValue] == 0)
    {
        _salonRating.rating = 0;
        _ratingLabel.text = @"0";
        _nbReviews.text = @"- 0 review";
    }
    else
    {
        _salonRating.rating = [[reviews objectForKey:@"average"] floatValue];
        _ratingLabel.text = [[reviews objectForKey:@"average"] stringValue];
        _nbReviews.text =[NSString stringWithFormat:@"- %@ reviews",[reviews objectForKey:@"total"]];
    }
    _address.text = [salonDetail objectForKey:@"street"];
    _city.text = [salonDetail objectForKey:@"city"];
    
    
    //_salonAvailability
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
