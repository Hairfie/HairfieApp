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
#import "HorairesViewController.h"
#import "CustomCollectionViewCell.h"
#import "HairdressersTableViewCell.h"
#import "PricesTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SalonDetailViewController ()

@end

@implementation SalonDetailViewController {
    BOOL isOpen;
    // Variables de test (vu qu'il y a pas de backend)
    
    NSArray *coiffureArray;
    NSArray *coiffeurArray;
}

@synthesize imageSliderView =_imageSliderView, pageControl = _pageControl,hairfieView = _hairfieView, hairdresserView = _hairdresserView, priceAndSaleView = _priceAndSaleView, infoBttn = _infoBttn, hairfieBttn = _hairfieBttn, hairdresserBttn = _hairdresserBttn, priceAndSaleBttn = _priceAndSaleBttn, reviewRating = _reviewRating, reviewTableView = _reviewTableView, addReviewBttn = _addReviewBttn, moreReviewBttn = _moreReviewBttn, similarTableView = _similarTableView, business = _business, ratingLabel = _ratingLabel, name = _name , womanPrice = _womanPrice, manPrice = _manPrice, salonRating = _salonRating, address = _address, city = _city, salonAvailability = _salonAvailability, nbReviews = _nbReviews, previewMap = _previewMap, isOpenLabel = _isOpenLabel, isOpenLabelDetail = _isOpenLabelDetail, isOpenImage = _isOpenImage, isOpenImageDetail = _isOpenImageDetail, callBttn = _callBttn, telephoneBgView = _telephoneBgView, detailedContainerView = _detailedContainerView;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initKnownData:_business];
    [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
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
    _similarTableView.userInteractionEnabled = NO;
    _similarTableView.scrollEnabled = NO;
    _similarTableView.backgroundColor = [UIColor clearColor];
    
    _addReviewBttn.layer.cornerRadius = 5;
    _addReviewBttn.layer.masksToBounds = YES;
    
    _moreReviewBttn.layer.cornerRadius = 5;
    _moreReviewBttn.layer.masksToBounds = YES;
    
    _telephoneBgView.layer.cornerRadius = 5;
    _telephoneBgView.layer.masksToBounds = YES;
    
    _previewMap.layer.cornerRadius = 5;
    _previewMap.layer.masksToBounds = YES;
    _previewMap.layer.borderWidth = 3;
    _previewMap.layer.borderColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1].CGColor;
    _previewMap.delegate = self;
    
    coiffeurArray = [[NSArray alloc] init];
    coiffeurArray = [[NSArray alloc] initWithObjects:@"Charlyne M.", @"Johanna G.", @"Lisa T.", @"Audrey M.", @"Ghislain J.", nil];
    _hairdresserTableViewHeight.constant = [coiffeurArray count] * 60;
    _hairdresserTableView.scrollEnabled = NO;
    
    coiffureArray = [[NSArray alloc] init];
    coiffureArray = [[NSArray alloc] initWithObjects:@"COUPE HOMME BASIQUE", @"COUPE HOMME BASIQUE", @"LISSAGE BRESILIEN", @"COLORATION", @"BRUSHING", nil];
    _pricesTableViewHeight.constant = [coiffureArray count] * 41;
    
    
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
    
    // Do any additional setup after loading the view.
    
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
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:[pictures objectAtIndex:i]]
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


-(IBAction)changeTab:(id)sender {
    if(sender == _infoBttn){
    [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
      
         _mainViewHeight.constant = 1030;
          _infoView.hidden = NO;
    }
    else if(sender == _hairfieBttn) {
        
    [self setButtonSelected:_hairfieBttn andBringViewUpfront:_hairfieView];
    _mainViewHeight.constant = 980;
     _hairfieView.hidden = NO;
    }
    else if(sender == _hairdresserBttn) {
          _mainViewHeight.constant = 600;
        [self setButtonSelected:_hairdresserBttn andBringViewUpfront:_hairdresserView];
        _hairdresserView.hidden = NO;
    }
    else if(sender == _priceAndSaleBttn) {
          _mainViewHeight.constant = 600;
        [self setButtonSelected:_priceAndSaleBttn andBringViewUpfront:_priceAndSaleView];
         _priceAndSaleView.hidden = NO;
    }
}

-(void)setButtonSelected:(UIButton*) button andBringViewUpfront:(UIView*) view {
    [_containerView bringSubviewToFront:view];
    [self unSelectAll];
    [button setBackgroundColor:[UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:1]];
}

-(void) setNormalStateColor:(UIButton*) button
{
    [button setBackgroundColor:[UIColor colorWithRed:50/255.0f green:67/255.0f blue:87/255.0f alpha:0.9]];
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
    if (tableView == _reviewTableView)
        return 2;
    else if (tableView == _similarTableView)
        return self.similarBusinesses.count;
    if (tableView == _hairdresserTableView)
        return 5;
    if(tableView == _pricesTableView)
        return 5;
    return 2;
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
        
        [cell customInit:self.similarBusinesses[indexPath.row]];
        
        return cell;
    }
    else if (tableView == _hairdresserTableView)
    {
        static NSString *CellIdentifier = @"hairdresserCell";
        HairdressersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairdressersTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }

        cell.name.text = [coiffeurArray objectAtIndex:indexPath.row];
        cell.nbHairfie.text = @"335 Hairfies";
        cell.nbHairfie.textColor = [UIColor colorWithRed:224/255.0f green:106/255.0f blue:71/255.0f alpha:1];
        return cell;
    }
    
    else if (tableView == _pricesTableView)
    {
        static NSString *CellIdentifier = @"priceCell";
        PricesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PricesTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.itemName.text = [coiffureArray objectAtIndex:indexPath.row];
        cell.price.text = @"$ 100";
        return cell;
    }

    
    return nil;
}

- (void) initKnownData:(Business*)business
{
    [self setupCrossSell];
    
    [self setupHairfies];
    
    [self setupGallery:business.pictures];
    
    if (![[business timetable] isEqual:[NSNull null]]) {
        _isOpenImageDetail.hidden = YES;
        _isOpenLabelDetail.hidden = YES;
        _isOpenLabel.text = @"Pas d'informations";
    } else {
        OpeningTimes * op = [[OpeningTimes alloc] init];
        isOpen = [op isOpen:business.timetable];
        if (isOpen) {
            _isOpenLabel.text = @"Ouvert aujourd'hui";
            _isOpenLabel.textColor = [UIColor greenHairfie];
            
            _isOpenImage.image = [_isOpenImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_isOpenImage setTintColor:[UIColor greenHairfie]];
        }
        else {
            _isOpenLabel.text = @"Fermé aujourd'hui";
        }
    }

    if ([[business phoneNumbers] isEqual:[NSNull null]] || business.phoneNumbers.count == 0)
    {
        _telephone.text = [NSString stringWithFormat:@"Pas de numéro connu"];
        _telephoneLabelWidth.constant = 133;
        _isPhoneAvailable.hidden = YES;
    }
    else
    {
        [self addPhoneNumbersToView];
        
    }
    _name.text = business.name;
    
    if ([[[business prices] objectForKey:@"women"] integerValue] != 0 && [[[business prices] objectForKey:@"men"]integerValue] != 0)
    {
        _manPrice.text = [NSString stringWithFormat:@"%@ €",[[[business prices] objectForKey:@"men"] stringValue]];
        _womanPrice.text = [NSString stringWithFormat:@"%@ €",[[[business prices] objectForKey:@"women"] stringValue]];
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
    

    if (business.numReviews == 0)
    {
        _salonRating.rating = 0;
        _ratingLabel.text = @"0";
        _nbReviews.text = @"- 0 review";
        _reviewTableView.hidden = YES;
        _addReviewButtonYpos.constant = 338;
        _addReviewButtonXpos.constant = 200;
        _moreReviewBttn.hidden = YES;
        _moreReviewBttn.enabled = NO;
        _mainViewHeight.constant = 1030;
    }
    else
    {
        _salonRating.rating = [[business ratingBetween:@0 and: @5] floatValue];
        _ratingLabel.text = [[business ratingBetween:@0 and:@5] stringValue];
        _nbReviews.text =[NSString stringWithFormat:@"- %@ reviews", business.numReviews];
    }
    
    _address.text = business.address.street;
    _zipCode.text = business.address.zipCode;
    _city.text = business.address.city;
    
    // MapView Setup
    _haidresserLat = [NSString stringWithFormat:@"%@", business.gps.latitude];
    _haidresserLng = [NSString stringWithFormat:@"%@", business.gps.longitude];

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
                        NSLog(error.localizedDescription);
                    }];
}

-(void)setupHairfies
{
    [Hairfie listLatestByBusiness:self.business.id
                            limit:@10
                             skip:@0
                          success:^(NSArray *hairfies) {
                              NSLog(@"Fetched %d hairfie(s)", hairfies.count);
                              self.hairfies = hairfies;
                              [self.hairfieCollection reloadData];
                          }
                          failure:^(NSError *error) {
                              NSLog(error.localizedDescription);
                          }];
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
    NSLog(@"callPhone %@", [self.business.phoneNumbers objectAtIndex:0]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [self.business.phoneNumbers objectAtIndex:0]]]];
}

-(IBAction)callPhoneWithNumber:(UIButton *)sender {

    NSString *number = [self.business.phoneNumbers objectAtIndex:sender.tag];
    NSLog(@"callPhone %@", number);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]]];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addReview"])
    {
        ReviewsViewController *review = [segue destinationViewController];
        review.ratingValue = _reviewRating.rating;
        review.isReviewing = YES;
    }
    if ([segue.identifier isEqualToString:@"showTimetable"])
    {
        HorairesViewController *horaires = [segue destinationViewController];
       
        
        
        horaires.salon = _business.timetable;
    }
}

-(void)addPhoneNumbersToView
{
    _telephone.hidden = YES;
    _telephoneBgView.hidden = YES;
    
    #define OffsetBetweenButtons 135
    
    for(int buttonIndex=0; buttonIndex<[self.business.phoneNumbers count]; buttonIndex++){
    
        UIButton *phoneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        NSString *phone =[self.business.phoneNumbers objectAtIndex:buttonIndex];
        
        phoneBtn.frame= CGRectMake(35 + OffsetBetweenButtons * buttonIndex, 75, 115, 25);
        phoneBtn.backgroundColor = [UIColor lightBlueHairfie];
        phoneBtn.layer.cornerRadius = 5;
        phoneBtn.layer.masksToBounds = YES;
        
        phoneBtn.tag = buttonIndex;
        
        [phoneBtn setTitle:[self formatPhoneNumber:phone] forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [phoneBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];
        
        [phoneBtn addTarget:self action:@selector(callPhoneWithNumber:) forControlEvents:UIControlEventTouchUpInside];
        [_detailedContainerView addSubview:phoneBtn];
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


// Collection View Delegate

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.hairfies.count;
}

-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

-(CustomCollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"hairfieCell";
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell setHairfie:self.hairfies[indexPath.row]];
    
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
