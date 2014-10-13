//
//  SalonDetailViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 04/08/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "SalonDetailViewController.h"
#import "HairfieDetailViewController.h"
#import "ReviewTableViewCell.h"
#import "SimilarTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#import "ReviewsViewController.h"
#import "HorairesViewController.h"
#import "CustomCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"
#import "HairdressersTableViewCell.h"
#import "PricesTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "NotLoggedAlert.h"
#import "Hairdresser.h"

@interface SalonDetailViewController ()

@end

@implementation SalonDetailViewController {
    // Variables de test (vu qu'il y a pas de backend)
    NSArray *coiffeurArray;
    
    NSMutableArray *hairfies;
    BOOL endOfHairfies;
    BOOL loadingHairfies;
    AppDelegate *delegate;

    NSArray *menuActions;

    NSArray *latestReviews;
    BOOL loadingLastestReviews;
}

@synthesize imageSliderView =_imageSliderView, pageControl = _pageControl,hairfieView = _hairfieView, hairdresserView = _hairdresserView, priceAndSaleView = _priceAndSaleView, infoBttn = _infoBttn, hairfieBttn = _hairfieBttn, hairdresserBttn = _hairdresserBttn, priceAndSaleBttn = _priceAndSaleBttn, reviewRating = _reviewRating, reviewTableView = _reviewTableView, addReviewBttn = _addReviewBttn, moreReviewBttn = _moreReviewBttn, similarTableView = _similarTableView, business = _business, name = _name , womanPrice = _womanPrice, manPrice = _manPrice, salonRating = _salonRating, address = _address, city = _city, salonAvailability = _salonAvailability, nbReviews = _nbReviews, previewMap = _previewMap, isOpenLabel = _isOpenLabel, isOpenLabelDetail = _isOpenLabelDetail, isOpenImage = _isOpenImage, isOpenImageDetail = _isOpenImageDetail, callBttn = _callBttn, telephoneBgView = _telephoneBgView, detailedContainerView = _detailedContainerView;



- (void)viewDidLoad {
    [super viewDidLoad];
    _isAddingHairfie = NO;
    [self initKnownData:_business];
    [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
    
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    _infoView.hidden = NO;
    _imageSliderView.canCancelContentTouches = NO;
    _hairfieCollection.scrollEnabled = NO;
    
    _pricesTableView.layer.borderWidth = 1;
    _pricesTableView.layer.borderColor = [UIColor lightGreyHairfie].CGColor;
    [_pricesTableView setSeparatorInset:UIEdgeInsetsZero];
    
    _reviewTableView.delegate = self;
    _reviewTableView.dataSource = self;
    _reviewTableView.userInteractionEnabled = NO;
    _reviewTableView.scrollEnabled = NO;
    _reviewTableView.backgroundColor = [UIColor clearColor];
    
    _similarTableView.delegate = self;
    _similarTableView.dataSource = self;
    _similarTableView.userInteractionEnabled = YES;
    _similarTableView.scrollEnabled = NO;
    _similarTableView.backgroundColor = [UIColor clearColor];
    
    _addReviewBttn.layer.cornerRadius = 5;
    _addReviewBttn.layer.masksToBounds = YES;
    
    _moreReviewBttn.layer.cornerRadius = 5;
    _moreReviewBttn.layer.masksToBounds = YES;
    
    _telephoneBgView.layer.cornerRadius = 5;
    _telephoneBgView.layer.masksToBounds = YES;
    
    if (_business.hairdressers.count > 0)
        _hairdresserTableViewHeight.constant = [_business.hairdressers count] * 60;
    else
        _hairdresserTableViewHeight.constant = 60;
    _hairdresserTableView.scrollEnabled = NO;

    // Init Rating View
    
    _reviewRating.notSelectedImage = [UIImage imageNamed:@"not_selected_review.png"];
    _reviewRating.halfSelectedImage = [UIImage imageNamed:@"half_selected_review.png"];
    _reviewRating.fullSelectedImage = [UIImage imageNamed:@"selected_review.png"];
    _reviewRating.rating = 0;
    _reviewRating.editable = YES;
    _reviewRating.maxRating = 5;
    _reviewRating.delegate = self;
    
    
    // Hairfie View
    
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hairfieCell"];
    
    [_hairfieCollection registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil]
         forCellWithReuseIdentifier:@"loadingCell"];
    
    // Do any additional setup after loading the view.

    menuActions = @[
        @{@"label": @"Report an error", @"segue": @"reportError"}
    ];

}

-(void) setupGallery:(NSArray*) pictures
{
    if ([pictures count] == 1)
        _pageControl.hidden = YES;
    if ([pictures count] == 0)
    {
        _pageControl.numberOfPages = 1;
        _pageControl.hidden = YES;
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = _imageSliderView.frame.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:@"default-picture.jpg"];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [_imageSliderView addSubview:imageView];
    }
    else {
        
    _pageControl.numberOfPages = [pictures count];
    for (int i = 0; i < [pictures count]; i++) {
        CGRect frame;
        frame.origin.x = _imageSliderView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _imageSliderView.frame.size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:[pictures[i] urlWithWidth:@640 height:@360]]
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize) { }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image && finished)
             {
                 imageView.image = image;
             }
         }];

        imageView.contentMode = UIViewContentModeScaleToFill;
        [_imageSliderView addSubview:imageView];
    }
   
    }
    _imageSliderView.pagingEnabled = YES;
    _imageSliderView.contentSize = CGSizeMake(_imageSliderView.frame.size.width * [pictures count], _imageSliderView.frame.size.height);
}

-(IBAction)showTimeTable:(id)sender
{
    if (_isOpenLabelDetail.hidden == NO)
        [self performSegueWithIdentifier:@"showTimetable" sender:self];
}
        
-(void)viewWillAppear:(BOOL)animated
{
    [self updateMapView];
    _reviewRating.rating = 0;
    [ARAnalytics pageView:@"AR - Business Detail"];
    [ARAnalytics event:@"AR - Business Detail" withProperties:@{@"Business ID": _business.id, @"Name": _business.name}];
    
    [_reviewTableView reloadData];
    [self setNormalStateColor:_hairfieBttn];
    [self setNormalStateColor:_hairdresserBttn];
    [self setNormalStateColor:_priceAndSaleBttn];
    if (_isAddingHairfie == YES)
    {
        [self setButtonSelected:_hairfieBttn andBringViewUpfront:_hairfieView];
        _hairfieView.hidden = NO;
        [self updateHairfiesView];
        _isAddingHairfie = NO;
    }
    
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)rateView:(RatingView *)rateView ratingDidChange:(float)rating {
    if(delegate.currentUser) {
        [self performSegueWithIdentifier:@"addReview" sender:self];

    } else {
        [self showNotLoggedAlertWithDelegate:nil andTitle:nil andMessage:nil];
        _reviewRating.rating = 0;
    }
}

-(IBAction)addReview:(id)sender
{
    _reviewRating.rating = 0;
    if(delegate.currentUser) {
        [self performSegueWithIdentifier:@"addReview" sender:self];
        
    } else {
        [self showNotLoggedAlertWithDelegate:nil andTitle:nil andMessage:nil];
    }
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


-(IBAction)changeTab:(id)sender {
    if(sender == _infoBttn) {
        [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
        _mainViewHeight.constant = 1030;
        _infoView.hidden = NO;
    } else if(sender == _hairfieBttn) {
        [self setButtonSelected:_hairfieBttn andBringViewUpfront:_hairfieView];
        _hairfieView.hidden = NO;
        [self updateHairfiesView];
    } else if(sender == _hairdresserBttn) {
        _mainViewHeight.constant = 600;
        [self setButtonSelected:_hairdresserBttn andBringViewUpfront:_hairdresserView];
        _hairdresserView.hidden = NO;
    } else if(sender == _priceAndSaleBttn) {
        _mainViewHeight.constant = 600;
        [self setButtonSelected:_priceAndSaleBttn andBringViewUpfront:_priceAndSaleView];
        _priceAndSaleView.hidden = NO;
    }
}

-(void)setButtonSelected:(UIButton*) button andBringViewUpfront:(UIView*) view {
    [self unSelectAll];
    [button.imageView setTintColor:[UIColor salonDetailTab]];
    [button setImage:button.imageView.image forState:UIControlStateNormal];
    button.imageView.image = [button.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_containerView bringSubviewToFront:view];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height, button.frame.size.width, 3)];
    bottomBorder.backgroundColor = [UIColor salonDetailTab];
    bottomBorder.tag = 1;
    [button addSubview:bottomBorder];
}

-(void) setNormalStateColor:(UIButton*) button
{
    [button.imageView setTintColor:[UIColor greyHairfie]];
    [button setImage:button.imageView.image forState:UIControlStateNormal];
    button.imageView.image = [button.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    for (UIView *subView in button.subviews) {
        if (subView.tag == 1) [subView removeFromSuperview];
    }
}

-(void) unSelectAll
{
    _infoView.hidden = YES;
    _hairfieView.hidden = YES;
    _hairdresserView.hidden = YES;
    _priceAndSaleView.hidden = YES;
    [self setNormalStateColor:_infoBttn];
    [self setNormalStateColor:_hairfieBttn];
    [self setNormalStateColor:_hairdresserBttn];
    [self setNormalStateColor:_priceAndSaleBttn];
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
    if (tableView == _reviewTableView) {
        return latestReviews.count;
    } else if (tableView == _similarTableView) {
        return self.similarBusinesses.count;
    } else if (tableView == _hairdresserTableView) {
        if (self.business.hairdressers.count > 0)
            return self.business.hairdressers.count;
        else
            return 1;
    } else if(tableView == _pricesTableView) {
        return self.business.services.count;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _reviewTableView)
        return 130;
    else if (tableView == _similarTableView)
        return 110;
    else if (tableView == _hairdresserTableView)
        return 60;
    else if (tableView == _pricesTableView)
        return 41;
    else
        return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (tableView == _reviewTableView) {
        static NSString *CellIdentifier = @"reviewCell";
        ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.review = latestReviews[indexPath.row];

        return cell;
    } else if (tableView == _similarTableView) {
        static NSString *CellIdentifier = @"similarCell";
        SimilarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimilarTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.business = self.similarBusinesses[indexPath.row];
        cell.locationForDistance = self.business.gps;
        return cell;
    } else if (tableView == _hairdresserTableView) {
        static NSString *CellIdentifier = @"hairdresserCell";
        HairdressersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairdressersTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if ([_business.hairdressers count] > 0) {
            Hairdresser *hairdresser = [_business.hairdressers objectAtIndex:indexPath.row];
            cell.name.text = [hairdresser displayFullName];
           
        }
         cell.disclosureImg.hidden = YES;
        return cell;
    } else if (tableView == _pricesTableView) {
        static NSString *CellIdentifier = @"priceCell";
        PricesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PricesTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if ([_business.services count] > 0)
        [cell updateWithService:self.business.services[indexPath.row]];

        return cell;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _similarTableView) {
        [self performSegueWithIdentifier:@"similarBusiness" sender:self.similarBusinesses[indexPath.row]];
    }
}

- (void) initKnownData:(Business*)business
{
    [self setupCrossSell];
    
    [self setupHairfies];
    
    [self setupGallery:business.pictures];
    
    [self setupPrices];

    [self setupLastReviews];
    
    if (nil == business.timetable) {
        _isOpenImageDetail.hidden = YES;
        _isOpenLabelDetail.hidden = YES;
        _isOpenLabel.text = NSLocalizedStringFromTable(@"No information", @"Salon_Detail", nil);
    } else {
        if (business.timetable.isOpenToday) {
            _isOpenLabel.text = NSLocalizedStringFromTable(@"Open today", @"Salon_Detail", nil);
            _isOpenLabel.textColor = [UIColor greenHairfie];
            
            _isOpenImage.image = [_isOpenImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_isOpenImage setTintColor:[UIColor greenHairfie]];
        }
        else {
            _isOpenLabel.text = NSLocalizedStringFromTable(@"Closed today", @"Salon_Detail", nil);
        }
    }

    if ([business.phoneNumber isEqual:[NSNull null]]) {
        _telephone.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"No phone number", @"Salon_Detail", nil)];
        _telephoneLabelWidth.constant = 133;
        _isPhoneAvailable.hidden = YES;
    } else {
        [self addPhoneNumbersToView];
        
    }
    _name.text = business.name;
    
    _pricesView.hidden = YES;
    
    _salonRating.notSelectedImage = [UIImage imageNamed:@"not_selected_star.png"];
    _salonRating.halfSelectedImage = [UIImage imageNamed:@"half_selected_star.png"];
    _salonRating.fullSelectedImage = [UIImage imageNamed:@"selected_star.png"];
    _salonRating.editable = NO;
    _salonRating.maxRating = 5;
    _salonRating.delegate = self;
    _salonRating.rating = [[business ratingBetween:@0 and: @5] floatValue];

    if ([business.numReviews isEqualToNumber:@0]) {
        // hide reviews list
        _reviewTableView.hidden = YES;
        _moreReviewBttn.hidden = YES;
        _moreReviewBttn.enabled = NO;
        _mainViewHeight.constant = 1030;
        _addReviewButtonYpos.constant = 308;
        _addReviewButtonXpos.constant = 200;
    } else {
        [_moreReviewBttn setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"more (%@)", @"Salon_Detail", nil), business.numReviews]
                         forState:UIControlStateNormal];
    }

    if ([business.numReviews isEqualToNumber:@0] || [business.numReviews isEqualToNumber:@1]) {
        _nbReviews.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ review", @"Salon_Detail", nil), business.numReviews];
    } else {
        _nbReviews.text =[NSString stringWithFormat:NSLocalizedStringFromTable(@"%@ reviews", @"Salon_Detail", nil), business.numReviews];
    }
    
    _address.text = business.address.street;
    _zipCode.text = business.address.zipCode;
    _city.text = business.address.city;
    
    // MapView Setup
    _haidresserLat = [NSString stringWithFormat:@"%@", business.gps.lat];
    _haidresserLng = [NSString stringWithFormat:@"%@", business.gps.lng];

}

-(void)setupPrices
{
    _pricesTableViewHeight.constant = self.business.services.count * 41;
}

-(void)setupCrossSell
{
    if (!self.business.crossSell) return;
    
    [Business listSimilarTo:self.business.id
                      limit:@3
                    success:^(NSArray *businesses) {
                        self.similarBusinesses = businesses;
                        [self.similarTableView reloadData];
                    }
                    failure:^(NSError *error) {
                        NSLog(@"%@", error.localizedDescription);
                    }];
}

-(void)setupLastReviews
{
    if ([self.business.numReviews isEqualToNumber:@0]) {
        loadingLastestReviews = NO;
        return;
    }
    
    if (loadingLastestReviews) {
        return;
    }
    
    loadingLastestReviews = YES;
    
    [BusinessReview listLatestByBusiness:self.business.id
                                   limit:@2
                                    skip:@0
                                 success:^(NSArray *reviews) {
                                     latestReviews = reviews;
                                     loadingLastestReviews = NO;
                                     [self.reviewTableView reloadData];
                                 }
                                 failure:^(NSError *error) {
                                     NSLog(@"Failed to load last reviews: %@", error.localizedDescription);
                                     loadingLastestReviews = NO;
                                 }];
}

-(void)setupHairfies
{
    hairfies = [[NSMutableArray alloc] init];
    endOfHairfies = NO;
    loadingHairfies = NO;
    
    [self loadNextHairfies];
}

-(void)loadNextHairfies
{
    if (endOfHairfies || loadingHairfies) return;

    NSLog(@"Loading next hairfies");

    NSDate *until = nil;
    if (hairfies.count > 0) {
        until = [hairfies[0] createdAt];
    }
    
    loadingHairfies = YES;
    
    [Hairfie listLatestByBusiness:self.business.id
                            until:until
                            limit:[NSNumber numberWithInt:HAIRFIES_PAGE_SIZE]
                             skip:[NSNumber numberWithLong:hairfies.count]
                          success:^(NSArray *results) {
                              NSLog(@"Got hairfies");
                              
                              if (results.count < HAIRFIES_PAGE_SIZE) {
                                  NSLog(@"End of hairfies detected");
                                  endOfHairfies = YES;
                              }
                              
                              for (Hairfie *result in results) {
                                  if (![hairfies containsObject:result]) {
                                      [hairfies addObject:result];
                                  }
                              }
                              
                              [self updateHairfiesView];
                              
                              loadingHairfies = NO;
                          }
                          failure:^(NSError *error) {
                              NSLog(@"%@", error.localizedDescription);
                              loadingHairfies = NO;
                          }];
}

-(void)updateHairfiesView
{
    
    NSLog(@"hairfies %@", hairfies);
    
    if (_hairfieView.hidden) return;
    
    
    NSInteger hairfieCount = [hairfies count] + 1;
    
    if (hairfieCount % 2 != 0) {
        hairfieCount += 1;
    }
   
    
    NSInteger height =  hairfieCount / 2 * 250 + 38 + _callBttn.frame.size.height;
    if ([hairfies count] %2 == 0)
        height += 80;
    if ([hairfies count] == 1)
        height = 360;
   
    _mainViewHeight.constant = height + 238 ;
    self.hairfieCollectionHeight.constant = height;
    [self.hairfieCollection reloadData];
}

- (void)updateMapView {
    
    CLLocationCoordinate2D coord;
    coord.longitude = [[NSString stringWithFormat:@"%@", _haidresserLng] floatValue];
    coord.latitude = [[NSString stringWithFormat:@"%@", _haidresserLat] floatValue];
    MyAnnotation *annotObj =[[MyAnnotation alloc]init];
    annotObj.title = _name.text;
    annotObj.coordinate = coord;
    [_previewMap addAnnotation:annotObj];
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
    NSLog(@"callPhone %@", self.business.phoneNumber);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.business.phoneNumber]]];
}

-(IBAction)callPhoneWithNumber:(UIButton *)sender
{
    NSLog(@"callPhone %@", self.business.phoneNumber);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.business.phoneNumber]]];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addReview"]) {
        ReviewsViewController *review = [segue destinationViewController];
        review.ratingValue = _reviewRating.rating;
        if (_reviewRating.rating != 0)
            review.isReviewing = YES;
        review.business = _business;
        review.addReviewButton.hidden = NO;
        
    } else if ([segue.identifier isEqualToString:@"showTimetable"]) {
        HorairesViewController *horaires = [segue destinationViewController];
        horaires.timetable = _business.timetable;
    } else if ([segue.identifier isEqualToString:@"hairfieDetail"]) {
        HairfieDetailViewController *hairfieDetail = [segue destinationViewController];
        hairfieDetail.hairfie = sender;
    } else if ([segue.identifier isEqualToString:@"similarBusiness"]) {
        SalonDetailViewController *controller = [segue destinationViewController];
        controller.business = sender;
    } else if ([segue.identifier isEqualToString:@"reportError"]) {
        [[segue destinationViewController] setBusiness:self.business];
    }
}

-(void)addPhoneNumbersToView
{
    _telephone.hidden = YES;
    _telephoneBgView.hidden = YES;

    UIButton *phoneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];

    phoneBtn.frame= CGRectMake(35, 75, 115, 25);
    phoneBtn.backgroundColor = [UIColor lightBlueHairfie];
    phoneBtn.layer.cornerRadius = 5;
    phoneBtn.layer.masksToBounds = YES;

    [phoneBtn setTitle:[self formatPhoneNumber:self.business.phoneNumber] forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];
    [phoneBtn addTarget:self action:@selector(callPhoneWithNumber:) forControlEvents:UIControlEventTouchUpInside];
    [_detailedContainerView addSubview:phoneBtn];
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


// Collection View Delegate

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return hairfies.count + 2; // +1 for the loading cell +1 for the button
}

-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < (hairfies.count + 1)) {
        return CGSizeMake(145, 210);
    } else {
        return CGSizeMake(300, 58);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        return [self collectionView:cv newHairfieCellForItemAtIndexPath:indexPath];
    } else if (indexPath.row < (hairfies.count + 1)) {
        if (indexPath.row >= (hairfies.count - HAIRFIES_PAGE_SIZE +1)) {
           // NSLog(@"Gimme more!");
            [self loadNextHairfies];
        }
        
        return [self collectionView:cv hairfieCellForItemAtIndexPath:indexPath];
    } else {
        return [self collectionView:cv loadingCellForItemAtIndexPath:indexPath];
    }
}

-(CustomCollectionViewCell *)collectionView:(UICollectionView *)cv newHairfieCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"hairfieCell" forIndexPath:indexPath];
    
    [cell setAsNewHairfieButton];
    
    return cell;
}

-(CustomCollectionViewCell *)collectionView:(UICollectionView *)cv hairfieCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"hairfieCell" forIndexPath:indexPath];

    [cell setHairfie:hairfies[indexPath.row - 1]];

    return cell;
}

-(LoadingCollectionViewCell *)collectionView:(UICollectionView *)cv loadingCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"loadingCell" forIndexPath:indexPath];

    if (endOfHairfies) {
        [cell showEndOfScroll];
    }

    return cell;
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        [self performSegueWithIdentifier:@"postHairfie" sender:nil];
        _isAddingHairfie = YES;
    } else {
        [self performSegueWithIdentifier:@"hairfieDetail" sender:hairfies[indexPath.row - 1]];
    }
}

-(IBAction)showMenuActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Salon_Detail", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for (NSDictionary *menuAction in menuActions) {
        [actionSheet addButtonWithTitle:NSLocalizedStringFromTable([menuAction objectForKey:@"label"], @"Salon_Detail", nil)];
    }
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) return; // it's the cancel button
    
    [self performSegueWithIdentifier:[menuActions[buttonIndex - 1] objectForKey:@"segue"] sender:self];
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
