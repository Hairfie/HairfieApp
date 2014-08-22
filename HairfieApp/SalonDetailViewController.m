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
    NSString *phoneNumber;
    
    // Variables de test (vu qu'il y a pas de backend)
    
    NSArray *coiffureArray;
    NSArray *coiffeurArray;
}

@synthesize imageSliderView =_imageSliderView, pageControl = _pageControl,hairfieView = _hairfieView, hairdresserView = _hairdresserView, priceAndSaleView = _priceAndSaleView, infoBttn = _infoBttn, hairfieBttn = _hairfieBttn, hairdresserBttn = _hairdresserBttn, priceAndSaleBttn = _priceAndSaleBttn, reviewRating = _reviewRating, reviewTableView = _reviewTableView, addReviewBttn = _addReviewBttn, moreReviewBttn = _moreReviewBttn, similarTableView = _similarTableView, dataSalon = _dataSalon, ratingLabel = _ratingLabel, name = _name , womanPrice = _womanPrice, manPrice = _manPrice, salonRating = _salonRating, address = _address, city = _city, salonAvailability = _salonAvailability, nbReviews = _nbReviews, previewMap = _previewMap, isOpenLabel = _isOpenLabel, isOpenLabelDetail = _isOpenLabelDetail, isOpenImage = _isOpenImage, isOpenImageDetail = _isOpenImageDetail, callBttn = _callBttn, telephoneBgView = _telephoneBgView;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initKnownData:_dataSalon];
    [self setButtonSelected:_infoBttn andBringViewUpfront:_infoView];
    _infoView.hidden = NO;
    _imageSliderView.canCancelContentTouches = NO;
    _hairfieCollection.scrollEnabled = NO;
    
    _pricesTableView.layer.borderWidth = 1;
    _pricesTableView.layer.borderColor = [UIColor colorWithRed:214/255.0f green:217/255.0f blue:221/255.0f alpha:1].CGColor;
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
        return 3;
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
        // Provisoire data
        
        cell.name.text = [NSString stringWithFormat:@"Similar salon %ld",indexPath.row + 1];
        cell.salonPicture.image = [UIImage imageNamed:@"placeholder-image.jpg"];
        
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

- (void) initKnownData:(NSDictionary*)salon
{
   
    NSDictionary *price = [salon objectForKey:@"price"];
    NSArray *phoneNumbers = [salon objectForKey:@"phone_numbers"];
    NSDictionary *reviews = [salon objectForKey:@"reviews"];
    NSDictionary *timetables =[salon objectForKey:@"timetables"];
    NSArray *pictures = [salon objectForKey:@"pictures"];
   
   [self setupGallery:pictures];

    if (!timetables) {
        NSLog(@"je devrais etre ici");
        _isOpenImageDetail.hidden = YES;
        _isOpenLabelDetail.hidden = YES;
         _isOpenLabel.text = @"Pas d'informations";
    }
    else {
        OpeningTimes * op = [[OpeningTimes alloc] init];
        isOpen = [op isOpen:timetables];
        if (isOpen) {
            UIColor *green = [UIColor colorWithRed:50/255.0 green:178/255.0 blue:81/255.0 alpha:1];
            _isOpenLabel.text = @"Ouvert aujourd'hui";
            _isOpenLabel.textColor = green;
            
            _isOpenImage.image = [_isOpenImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_isOpenImage setTintColor:green];
        }
        else {
            _isOpenLabel.text = @"Fermé aujourd'hui";
        }
    }

    if (phoneNumbers == nil || [phoneNumbers count] == 0)
    {
        _telephone.text = [NSString stringWithFormat:@"Pas de numéro connu"];
        _telephoneLabelWidth.constant = 133;
        _isPhoneAvailable.hidden = YES;
    }
    else
    {
        _telephone.text = [self formatPhoneNumber:[phoneNumbers objectAtIndex:0]];
        _telephoneLabelWidth.constant = 87;
        phoneNumber =[phoneNumbers objectAtIndex:0];
    }
    _name.text = [salon objectForKey:@"name"];
    
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
        _addReviewButtonYpos.constant = 338;
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
    
    _address.text = [[salon objectForKey:@"address"] valueForKey:@"street"];
    _zipCode.text = [[salon objectForKey:@"address"] valueForKey:@"zipcode"];
    _city.text = [[salon objectForKey:@"address"] valueForKey:@"city"];
    
    // MapView Setup
    _haidresserLat = [[salon objectForKey:@"gps"] valueForKey:@"lat"];
    _haidresserLng = [[salon objectForKey:@"gps"] valueForKey:@"lng"];

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
    if ([segue.identifier isEqualToString:@"showTimetable"])
    {
        HorairesViewController *horaires = [segue destinationViewController];
       
        
        
        horaires.salon = [_dataSalon objectForKey:@"timetables"];
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

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    _hairfieCollectionHeight.constant = (6 * 220) / 2;
    return 6;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


// 3
- (CustomCollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"hairfieCell";
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.name.text = @"Kimi Smith";
    cell.hairfieView.image = [UIImage imageNamed:@"hairfie.jpg"];
    cell.layer.borderColor = [UIColor colorWithRed:234/255.0f green:236/255.0f blue:238/255.0f alpha:1].CGColor;
    cell.layer.borderWidth = 1.0f;
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
