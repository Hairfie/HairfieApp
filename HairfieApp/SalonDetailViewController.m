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

@synthesize imageSliderView =_imageSliderView, pageControl = _pageControl, infoView = _infoView, hairfieView = _hairfieView, hairdresserView = _hairdresserView, salesView = _salesView, infoBttn = _infoBttn, hairfieBttn = _hairfieBttn, hairdresserBttn = _hairdresserBttn, salesBttn = _salesBttn;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    
    // Do any additional setup after loading the view.
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollview
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollview.frame.size.width;
    int page = floor((scrollview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}



-(IBAction)changeTab:(id)sender
{
    if(sender == _infoBttn)
        [self.view bringSubviewToFront:_infoView];
    else if(sender == _hairfieBttn)
        [self.view bringSubviewToFront:_hairfieView];
    else if(sender == _hairdresserBttn)
        [self.view bringSubviewToFront:_hairdresserView];
    else if(sender == _salesBttn)
        [self.view bringSubviewToFront:_salesView];
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
