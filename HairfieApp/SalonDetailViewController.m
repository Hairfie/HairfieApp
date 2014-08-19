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
#import "HairfieApp-Swift.h"
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#import "ReviewsViewController.h"

@interface SalonDetailViewController ()

@end

@implementation SalonDetailViewController {
    BOOL isOpen;
    NSString *phoneNumber;
}

@synthesize imageSliderView =_imageSliderView, pageControl = _pageControl,hairfieView = _hairfieView, hairdresserView = _hairdresserView, salesView = _salesView, infoBttn = _infoBttn, hairfieBttn = _hairfieBttn, hairdresserBttn = _hairdresserBttn, salesBttn = _salesBttn, reviewRating = _reviewRating, reviewTableView = _reviewTableView, addReviewBttn = _addReviewBttn, moreReviewBttn = _moreReviewBttn, similarTableView = _similarTableView, dataSalon = _dataSalon, ratingLabel = _ratingLabel, name = _name , womanPrice = _womanPrice, manPrice = _manPrice, salonRating = _salonRating, address = _address, city = _city, salonAvailability = _salonAvailability, nbReviews = _nbReviews, previewMap = _previewMap, isOpenLabel = _isOpenLabel, callBttn = _callBttn, telephoneBgView = _telephoneBgView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initKnownData:_dataSalon];
    [self unSelectAll];
    [_infoBttn setSelected:YES];
    _imageSliderView.canCancelContentTouches = NO;
    
    
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
    
    _callBttn.layer.cornerRadius = 5;
    _callBttn.layer.masksToBounds = YES;
    
    _telephoneBgView.layer.cornerRadius = 5;
    _telephoneBgView.layer.masksToBounds = YES;
    
    _previewMap.layer.cornerRadius = 5;
    _previewMap.layer.masksToBounds = YES;
    _previewMap.layer.borderWidth = 3;
    _previewMap.layer.borderColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1].CGColor;
    _previewMap.delegate = self;
  // LOAD Pictures in page control (horizontal scroll view)

    NSArray *tutoArray = [[NSArray alloc] init];
    tutoArray = [[NSArray alloc] initWithObjects:@"photo-example.jpeg", @"photo-example.jpeg", @"photo-example.jpeg", @"photo-example.jpeg", @"photo-example.jpeg", nil];
    _pageControl.numberOfPages = [tutoArray count];

    for (int i = 0; i < [tutoArray count]; i++) {
        CGRect frame;
        frame.origin.x = _imageSliderView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _imageSliderView.frame.size;
   
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
   
        
        imageView.image = [UIImage imageNamed:[tutoArray objectAtIndex:i]];
        imageView.contentMode = UIViewContentModeScaleToFill;
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

-(void)viewWillAppear:(BOOL)animated
{
    _reviewRating.rating = 0;
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    [self performSegueWithIdentifier:@"addReview" sender:self];
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
  /*  if(sender == _infoBttn)
        [self setButtonSelected:_infoBttn andBringViewUpfront:];
    else if(sender == _hairfieBttn)
        [self setButtonSelected:_hairfieBttn andBringViewUpfront:_hairfieView];
    else if(sender == _hairdresserBttn)
        [self setButtonSelected:_hairdresserBttn andBringViewUpfront:_hairdresserView];
    else if(sender == _salesBttn)
         [self setButtonSelected:_salesBttn andBringViewUpfront:_salesView];
   */
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
/*
    
    _hairfieBttn.selected = NO;
    _hairdresserBttn.selected = NO;
    _salesBttn.selected = NO;*/
}


-(IBAction)changePage:(id)sender {
    
    UIPageControl *pager = sender;
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
    if (tableView == _reviewTableView)
    return 2;
else if (tableView == _similarTableView)
    return 3;

    
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
    NSArray *phoneNumbers = [salonDetail objectForKey:@"phone_numbers"];
    NSDictionary *reviews = [salonDetail objectForKey:@"reviews"];
    NSDictionary *timetables =[salonDetail objectForKey:@"timetables"];
    
    if (timetables == nil)
        _isOpenLabel.text = @"Pas d'informations";
    else
    {
        OpeningTimes * op = [[OpeningTimes alloc] init];
        isOpen = [op isOpen:timetables];
        if (isOpen)
            _isOpenLabel.text = @"Ouvert aujourd'hui";
        else
            _isOpenLabel.text = @"Fermé aujourd'hui";
    }

    if (phoneNumbers == nil || [phoneNumbers count] == 0)
    {
        _telephone.text = [NSString stringWithFormat:@"Pas de numéro connu"];
        _telephoneLabelWidth.constant = 133;
        _callBttn.hidden = YES;
        _callBttn.enabled = NO;
    }
    else
    {
        _telephone.text = [self formatPhoneNumber:[phoneNumbers objectAtIndex:0]];
        _telephoneLabelWidth.constant = 87;
        phoneNumber =[phoneNumbers objectAtIndex:0];
    }
    
    _name.text = [salonDetail objectForKey:@"name"];
    
    if ([[price objectForKey:@"women"] integerValue] != 0 && [[price objectForKey:@"men"]integerValue] != 0)
    {
        _manPrice.text = [NSString stringWithFormat:@"%@ €",[[price objectForKey:@"men"] stringValue]];
        _womanPrice.text = [NSString stringWithFormat:@"%@ €",[[price objectForKey:@"women"] stringValue]];
        _pricesView.hidden = NO;
    }
    else
        _pricesView.hidden = YES;
    
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
        _reviewTableView.hidden = YES;
        _addReviewButtonYpos.constant = 590;
        _addReviewButtonXpos.constant = 200;
        _moreReviewBttn.hidden = YES;
        _moreReviewBttn.enabled = NO;
        _mainViewHeight.constant = 1030;
    }
    else
    {
        _salonRating.rating = [[reviews objectForKey:@"average"] floatValue];
        _ratingLabel.text = [[reviews objectForKey:@"average"] stringValue];
        _nbReviews.text =[NSString stringWithFormat:@"- %@ reviews",[reviews objectForKey:@"total"]];
    }
    
    _address.text = [salonDetail objectForKey:@"street"];
    _city.text = [salonDetail objectForKey:@"city"];
    
    // MapView Setup
    
    NSString *fullAddress = [NSString stringWithFormat:@"%@, %@", [salonDetail objectForKey:@"street"], [salonDetail objectForKey:@"city"]];
    [self getCoordinatesFromAdress:fullAddress];
}


-(void) getCoordinatesFromAdress:(NSString*)address
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark* aPlacemark in placemarks)
        {
            // Process the placemark.
            _haidresserLat = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
            _haidresserLng = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
             [self updateMapView];
            }
    }];

}


- (void)updateMapView {
    
    // create a region and pass it to the Map View
    CLLocationCoordinate2D coord;
    coord.longitude = [[NSString stringWithFormat:@"%@", _haidresserLng] floatValue];
    coord.latitude = [[NSString stringWithFormat:@"%@", _haidresserLat] floatValue];

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (coord, 260, 216);
    region.center = coord;
    
    MyAnnotation *annotObj =[[MyAnnotation alloc]init];
    
    annotObj.title = _name.text;
    annotObj.coordinate = coord;
    [_previewMap addAnnotation:annotObj];
//    [_previewMap regionThatFits:region];
    //[_previewMap setRegion:region animated:NO];
    [_previewMap showAnnotations:@[annotObj] animated:NO];
    _previewMap.camera.altitude = 1000;
  
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    
    static NSString *myIdentifier =@"MyAnnotation";
    if([annotation isKindOfClass:[MyAnnotation class]])
    {
        MKAnnotationView *annotationView=[mapView dequeueReusableAnnotationViewWithIdentifier:myIdentifier];
        if(!annotationView)
        {
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
            annotationView.image = [UIImage imageNamed:@"map_pin.png"];
            [annotationView setFrame:CGRectMake(0, 0, 17, 24)];
            annotationView.contentMode = UIViewContentModeScaleAspectFit;
            annotationView.centerOffset = CGPointMake(0, -annotationView.image.size.height / 2);
            annotationView.canShowCallout = YES;
        }
        return annotationView;
    }
    return nil;
}

-(IBAction)callPhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addReview"])
    {
        ReviewsViewController *review = [segue destinationViewController];
        review.ratingValue = _reviewRating.rating;
        review.isReviewing = YES;
    }
}


// add spaces every 2 char on phone number

-(NSString*)formatPhoneNumber:(NSString*) str
{
    NSMutableString* mStr= [NSMutableString string];
    for(NSUInteger i=0 ; i<str.length; i++)
    {
        [mStr appendString: [str substringWithRange: NSMakeRange(i,1)]];
        if(i%2 && i!=0)
        {
            [mStr appendString: @" "];
        }
    }
    return  mStr;
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
