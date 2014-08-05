//
//  SalonDetailViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 04/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SalonDetailViewController.h"

@interface SalonDetailViewController ()

@end

@implementation SalonDetailViewController

@synthesize imageSliderView =_imageSliderView, pageControl = _pageControl, infoView = _infoView, hairfieView = _hairfieView, hairdresserView = _hairdresserView, salesView = _salesView, infoBttn = _infoBttn, hairfieBttn = _hairfieBttn, hairdresserBttn = _hairdresserBttn, salesBttn = _salesBttn, ratingView = _ratingView;

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainScrollView.contentSize = CGSizeMake(320, 866);
    _mainScrollView.canCancelContentTouches = YES;
    _infoView.contentSize = CGSizeMake(320, 700);
    _infoView.scrollEnabled = NO;
//[_infoBttn setBackgroundColor:[UIColor colorWithRed:70/255 green:85/255 blue:103/255 alpha:1]];
    
  // LOAD Pictures in page control (horizontal scroll view)

    NSArray *tutoArray = [[NSArray alloc] init];
    tutoArray = [[NSArray alloc] initWithObjects:@"settings-picto.png", @"business-picto.png", @"likes-picto.png", @"home-picto.png", @"favorites-picto.png", nil];
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
    
    _ratingView.notSelectedImage = [UIImage imageNamed:@"not_selected_review.png"];
    _ratingView.halfSelectedImage = [UIImage imageNamed:@"half_selected_review.png"];
    _ratingView.fullSelectedImage = [UIImage imageNamed:@"selected_review.png"];
    _ratingView.rating = 0;
    _ratingView.editable = YES;
    _ratingView.maxRating = 5;
    _ratingView.delegate = self;
    
    
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
    if (scrollview == _mainScrollView)
    {
        if (_mainScrollView.contentOffset.y == 158.0)
        {
            _mainScrollView.scrollEnabled = NO;
            _infoView.scrollEnabled = YES;
        }
        
        NSLog(@"tetet %f", _mainScrollView.contentOffset.y);
    }
    if (scrollview == _infoView)
    {
            if (_infoView.contentOffset.y == 0)
            {
                _mainScrollView.scrollEnabled = YES;
                _infoView.scrollEnabled = NO;
            }
        
        NSLog(@"tette %f", _infoView.contentOffset.y);
    }
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSLog(@"jviens ici");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView == _infoView)
        
    {
        if (scrollView.contentOffset.y == 0)
            _mainScrollView.scrollEnabled = YES;
        
    }
    NSLog(@"jviens ici");
}

-(IBAction)changeTab:(id)sender
{
    NSLog(@"test");
    if(sender == _infoBttn)
    {
        [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
    }
    else if(sender == _hairfieBttn)
    {
        [self setButtonSelected:_hairfieBttn andBringViewUpfront:_hairfieView];
    }
    else if(sender == _hairdresserBttn)
    {
        [self setButtonSelected:_hairdresserBttn andBringViewUpfront:_hairdresserView];
    }
    else if(sender == _salesBttn)
    {
         [self setButtonSelected:_salesBttn andBringViewUpfront:_salesView];
    }
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
