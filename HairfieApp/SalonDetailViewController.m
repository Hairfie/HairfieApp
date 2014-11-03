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
#import "HairdresserTableViewCell.h"
#import "PricesTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "NotLoggedAlert.h"
#import "Hairdresser.h"
#import "NSString+PhoneFormatter.h"
#import "CameraOverlayViewController.h"
#import "HairfiePost.h"

@interface SalonDetailViewController ()

@end

@implementation SalonDetailViewController {
    NSMutableArray *hairfies;
    BOOL endOfHairfies;
    BOOL loadingHairfies;
    AppDelegate *delegate;

    NSArray *menuActions;

    NSArray *latestReviews;
    BOOL loadingLastestReviews;
    
    SalonDetailHeaderViewController *headerViewController;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    _isAddingHairfie = NO;
    [self setButtonSelected:self.infoBttn]; // slowest method call of this method
    delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _infoView.hidden = NO;
    _hairfieCollection.scrollEnabled = NO;
    
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

    _hairdresserTableView.scrollEnabled = NO;
    _hairdresserTableView.userInteractionEnabled= YES;
    // Init Rating View
    _containerReview.layer.cornerRadius = 5;
    _containerReview.layer.masksToBounds = YES;
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

    menuActions = @[
        @{@"label": NSLocalizedStringFromTable(@"Report an error", @"Salon_Detail",nil), @"segue": @"reportError"}
    ];
    
    headerViewController = [[SalonDetailHeaderViewController alloc] initWithNibName:@"SalonDetailHeaderViewController" bundle:nil];
    [headerViewController.view setFrame:self.headerContainerView.frame];
    [self addChildViewController:headerViewController];
    [self.headerContainerView addSubview:headerViewController.view];
    [headerViewController didMoveToParentViewController:self];
}

-(IBAction)showTimeTable:(id)sender
{
    if (_isOpenLabelDetail.hidden == NO)
        [self performSegueWithIdentifier:@"showTimetable" sender:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

-(void)viewWillAppear:(BOOL)animated
{
    
    _reviewRating.rating = 0;
    [ARAnalytics pageView:@"AR - Business Detail"];
    [ARAnalytics event:@"AR - Business Detail" withProperties:@{@"Business ID": _business.id, @"Name": _business.name}];
    [self initKnownData:_business];
    [_reviewTableView reloadData];
    
    if (_isAddingHairfie == YES)
    {
        [self setButtonSelected:_hairfieBttn];
        [self updateHairfiesView];
        _isAddingHairfie = NO;
    }
    
    if(_didClaim) {
        [_goBackBttn setHidden:YES];
    } else {
        [_menuBttn setHidden:YES];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(businessChanged:)
                                                 name:[Business EVENT_CHANGED]
                                               object:nil];
}

-(void)rateView:(RatingView *)rateView ratingDidChange:(float)rating
{
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

-(void)businessChanged:(NSNotification*)notification
{
    Business *changedBusiness = (Business *)notification.object;
    
    if (changedBusiness == self.business) {
        [self initKnownData:changedBusiness];
    }
}

-(IBAction)changeTab:(id)sender
{
    [self setButtonSelected:sender];
}

-(void)decorateButton:(UIButton *)aButton withImage:(NSString *)anImage active:(BOOL)isActive
{
    NSString *imageName;
    if (isActive) {
        imageName = [NSString stringWithFormat:@"tab-business-%@-active", anImage];
    } else {
        imageName = [NSString stringWithFormat:@"tab-business-%@", anImage];
    }
    
    [aButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

-(void)setButtonSelected:(UIButton*)aButton
{
    self.infoView.hidden = YES;
    self.hairfieView.hidden = YES;
    self.hairdresserView.hidden = YES;
    self.priceAndSaleView.hidden = YES;
    
    [self decorateButton:self.infoBttn withImage:@"infos" active:NO];
    [self decorateButton:self.hairfieBttn withImage:@"hairfies" active:NO];
    [self decorateButton:self.hairdresserBttn withImage:@"hairdressers" active:NO];
    [self decorateButton:self.priceAndSaleBttn withImage:@"prices" active:NO];

    if (aButton == self.infoBttn) {
        [self decorateButton:self.infoBttn withImage:@"infos" active:YES];
        [self.containerView bringSubviewToFront:self.infoView];
        self.infoView.hidden = NO;
        _mainViewHeight.constant = 1000;
    } else if (aButton == self.hairfieBttn) {
        [self decorateButton:self.hairfieBttn withImage:@"hairfies" active:YES];
        [self.containerView bringSubviewToFront:self.hairfieView];
        self.hairfieView.hidden = NO;
        _mainViewHeight.constant = 568 + (hairfies.count * 210) + _callBttn.frame.size.height + 210;
        
        [self updateHairfiesView];
    } else if (aButton == self.hairdresserBttn) {
        [self decorateButton:self.hairdresserBttn withImage:@"hairdressers" active:YES];
        [self.containerView bringSubviewToFront:self.hairdresserView];
        self.hairdresserView.hidden = NO;
        _mainViewHeight.constant = 568 + (_business.activeHairdressers.count * _hairdresserTableView.rowHeight);
    } else if (aButton == self.priceAndSaleBttn) {
        [self decorateButton:self.priceAndSaleBttn withImage:@"prices" active:YES];
        [self.containerView bringSubviewToFront:self.priceAndSaleView];
        self.priceAndSaleView.hidden = NO;
        _mainViewHeight.constant = 568 + (_business.services.count * _pricesTableView.rowHeight);
    }

    for (UIButton *btn in @[self.infoBttn, self.hairfieBttn, self.hairdresserBttn, self.priceAndSaleBttn]) {
        for (UIView *subView in btn.subviews) {
            if (subView.tag == 1) [subView removeFromSuperview];
        }
    }

    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, aButton.frame.size.height, aButton.frame.size.width, 3)];
    bottomBorder.backgroundColor = [UIColor salonDetailTab];
    bottomBorder.tag = 1;
    [aButton addSubview:bottomBorder];
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
        if (self.business.activeHairdressers.count > 0)
            return self.business.activeHairdressers.count;
        else
            return 1;
    } else if(tableView == _pricesTableView) {
        return self.business.services.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _reviewTableView)
        return 130;
    else if (tableView == _similarTableView)
        return 110;
    else if (tableView == _hairdresserTableView)
        return 45;
    else if (tableView == _pricesTableView)
        return 46;
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
        HairdresserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HairdresserTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if ([_business.activeHairdressers count] > 0) {
            Hairdresser *hairdresser = [_business.activeHairdressers objectAtIndex:indexPath.row];
            cell.fullName.text = [hairdresser displayFullName];
           
        }
        else
        {
            cell.fullName.text = NSLocalizedStringFromTable(@"No Hairdresser", @"Salon_Detail", nil);
            NSLog(@"HERE //////////////");
        }
        cell.clearButton.hidden = YES;
        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);

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
        cell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
        return cell;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _similarTableView) {
        [self performSegueWithIdentifier:@"similarBusiness" sender:self.similarBusinesses[indexPath.row]];
    }
    
    if (tableView == _hairdresserTableView)
    {
        if ([_business.activeHairdressers count] == 0)
        {
            [self performSegueWithIdentifier:@"suggestHairdresser" sender:self];
            [_hairdresserTableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
   }

- (void) initKnownData:(Business*)business
{
    [self setupCrossSell];
    [self setupHairfies];
    [self setupLastReviews];
    
    headerViewController.business = business;
    
    if (nil == business.timetable) {
        _isOpenImageDetail.hidden = YES;
        _isOpenLabelDetail.hidden = YES;
        _isOpenLabel.text = NSLocalizedStringFromTable(@"No information", @"Salon_Detail", nil);
    } else {
        if (business.timetable.isOpenToday) {
            if ([business.kind isEqualToString:KIND_ATHOME]) {
                _isOpenLabel.text = NSLocalizedStringFromTable(@"Works today", @"Salon_Detail", nil);
            } else {
                _isOpenLabel.text = NSLocalizedStringFromTable(@"Open today", @"Salon_Detail", nil);
            }
            _isOpenLabel.textColor = [UIColor greenHairfie];
            
            _isOpenImage.image = [_isOpenImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_isOpenImage setTintColor:[UIColor greenHairfie]];
        }
        else {
            if ([business.kind isEqualToString:KIND_ATHOME]) {
                _isOpenLabel.text = NSLocalizedStringFromTable(@"Does not work today", @"Salon_Detail", nil);
            } else {
                _isOpenLabel.text = NSLocalizedStringFromTable(@"Closed today", @"Salon_Detail", nil);
            }
        }
    }

    if ([business.phoneNumber isEqual:[NSNull null]]) {
        _telephone.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"No phone number", @"Salon_Detail", nil)];
        _telephoneLabelWidth.constant = 133;
        _isPhoneAvailable.hidden = YES;

    } else {
        [self addPhoneNumbersToView];
        
    }

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
        _mainViewHeight.constant = 1000;
        _addReviewButtonYpos.constant = 288;
        _addReviewButtonXpos.constant = 200;
    } else {
        NSInteger tes = MIN(2, [_business.numReviews integerValue]);
    
        _reviewTableView.hidden = NO;
        _moreReviewBttn.hidden = NO;
        _moreReviewBttn.enabled = YES;
        _addReviewButtonXpos.constant = 80;
        _addReviewButtonYpos.constant = 288 + (130 * tes);
        _moreReviewButtonYpos.constant = 288 + (130 * tes);
        [_moreReviewBttn setTitle:[NSString stringWithFormat:NSLocalizedStringFromTable(@"more (%@)", @"Salon_Detail", nil), business.numReviews]
                         forState:UIControlStateNormal];
    }
    
    _address.text = business.address.street;
    _city.text = business.address.city;
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



-(IBAction)callPhone:(id)sender {
    
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
    } else if ([segue.identifier isEqualToString:@"suggestHairdresser"]) {
        [[segue destinationViewController] setBusiness:self.business];
    } else if ([segue.identifier isEqualToString:@"postHairfie"]) {
        CameraOverlayViewController *controller = [segue destinationViewController];
        controller.hairfiePost = [[HairfiePost alloc] initWithBusiness:_business];
    }
}

-(void)addPhoneNumbersToView
{
    _telephone.hidden = YES;
    _telephoneBgView.hidden = YES;

    UIButton *phoneBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];

    phoneBtn.frame= CGRectMake(35, 85, 135, 20);
    phoneBtn.backgroundColor = [UIColor colorWithRed:250/255.0f green:66/255.0f blue:77/255.0f alpha:1];
    phoneBtn.layer.cornerRadius = 5;
    phoneBtn.layer.masksToBounds = YES;

    NSString *phoneBttnTitle = [[NSString alloc] init];

    phoneBttnTitle = [phoneBttnTitle formatPhoneNumber:self.business.phoneNumber];

    [phoneBtn setTitle:phoneBttnTitle forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [phoneBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];
    [phoneBtn addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    [_detailedContainerView addSubview:phoneBtn];
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
        } NSLog(@"Hairfie %zd", indexPath.row);

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

@end
