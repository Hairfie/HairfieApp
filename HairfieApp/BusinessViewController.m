//
//  BusinessViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessViewController.h"
#import "Hairfie.h"
#import "Service.h"
#import "BusinessMember.h"
#import "AppDelegate.h"

#import "HairfieDetailViewController.h"
#import "ReviewsViewController.h"
#import "SalonMapViewController.h"
#import "HorairesViewController.h"
#import "BusinessMemberViewController.h"
#import "HairfiePostCameraViewController.h"
#import "BusinessClaimExistingViewController.h"

#import "LoadingCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "BusinessDetailCollectionViewCell.h"
#import "BusinessHairdressersCollectionViewCell.h"
#import "BusinessServicesCollectionViewCell.h"
#import "BusinessPictureGalleryViewController.h"
#import "NewHairfieCollectionViewCell.h"

#import "FinalStepViewController.h"

#import "BusinessReusableView.h"
#import "NotLoggedAlert.h"
#import "BusinessMemberClaim.h"
#import "HairfieNotifications.h"
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface BusinessViewController ()

@end

@implementation BusinessViewController
{
    BOOL isHairfiesTab;
    BOOL isHairdressersTab;
    BOOL isDetailsTab;
    BOOL isServicesTab;
    
    NSMutableArray *businessHairfies;
    AppDelegate *appDelegate;
    BOOL endOfHairfies;
    BOOL loadingHairfies;
    Business *similarBusiness;
    Hairfie *hairfie;
    BusinessMember *businessMemberPicked;
    BOOL isSetup;
    BOOL isReviewing;
    NSNumber *ratingForReview;
    NSArray *menuActions;
    SalonDetailHeaderViewController *headerViewController;
}

#define HAIRFIE_CELL @"hairfieCell"
#define LOADING_CELL @"loadingCell"
#define DETAILS_CELL @"detailsCell"
#define HAIRDRESSERS_CELL @"businessHairdresserCell"
#define SERVICES_CELL @"businessServiceCell"
#define NEW_HAIRFIE_CELL_IDENTIFIER @"newHairfieCell"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isDetailsTab = YES;
     self.collectionView.allowsMultipleSelection = NO;
       appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

    if([appDelegate.credentialStore isLoggedIn]) {
        menuActions = @[
            @{@"label": NSLocalizedStringFromTable(@"Report an error", @"Salon_Detail",nil), @"segue": @"reportError"},
            @{@"label": NSLocalizedStringFromTable(@"Claim this business", @"Salon_Detail",nil), @"segue": @"claimExisting"},
            @{@"label": NSLocalizedStringFromTable(@"I am hairdresser in this salon", @"Salon_Detail", nil), @"action": @"claimBusinessMember"}
        ];
    } else {
        menuActions = @[
                        @{@"label": NSLocalizedStringFromTable(@"Report an error", @"Salon_Detail",nil), @"segue": @"reportError"}
                        ];
    }
    
    [self.callBttn setTitle:NSLocalizedStringFromTable(@"book", @"Salon_Detail", nil) forState:UIControlStateNormal];
    self.callBttnPicto.hidden = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBusinessDetails:)
                                                 name:@"businessDetails"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBusinessHairfies:)
                                                 name:@"businessHairfies"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBusinessHairdressers:)
                                                 name:@"businessHairdressers"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBusinessServices:)
                                                 name:@"businessServices"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showSimilarBusiness:)
                                                 name:@"similarBusinessPicked"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMoreReviews:)
                                                 name:@"showReviews"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNotLoggedIn:)
                                                 name:@"NoUserConnected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showBusinessMap:)
                                                 name:@"showBusinessMap"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showTimetable:)
                                                 name:@"showTimetable"
                                               object:nil];

    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:HAIRFIE_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewHairfieCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:NEW_HAIRFIE_CELL_IDENTIFIER];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:LOADING_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BusinessDetailCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:DETAILS_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BusinessHairdressersCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:HAIRDRESSERS_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BusinessServicesCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:SERVICES_CELL];
    
    
    [self initData];
    [self checkIfBusinessIsOwnedByUser:self.business];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self restrictRotation:YES];
    
    if(_didClaim) {
        [self.navBttn setHidden:YES];
    } else {
        [self.leftMenuBttn setHidden:YES];
    }
    [self.collectionView reloadData];
}

-(void)checkIfBusinessIsOwnedByUser:(Business*)aBusiness {
    for (int i = 0; i < appDelegate.currentUser.managedBusinesses.count; i++) {
        Business *business = [appDelegate.currentUser.managedBusinesses objectAtIndex:i];
        if ([aBusiness.id isEqualToString:business.id]) {
            [self.callBttn setTitle:NSLocalizedStringFromTable(@"Manage",@"Salon_Detail",nil) forState:UIControlStateNormal];
            self.callBttnPicto.hidden = YES;
            [self.callBttn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }
        }
}

-(void)initData
{
    [UIView setAnimationsEnabled:YES];
    [self setupHairfies];
}

-(IBAction)callBusiness:(id)sender {
    if (self.callBttnPicto.hidden == NO) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", self.business.phoneNumber]]];
    }
    else
    {
        [self performSegueWithIdentifier:@"editOwnedBusiness" sender:self];
    }
}

-(IBAction)showMenuActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    for( NSDictionary *button in menuActions)  {
        [actionSheet addButtonWithTitle:[button objectForKey:@"label"]];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"Cancel", @"Salon_Detail", nil)];
    actionSheet.cancelButtonIndex = [menuActions count];
    
    [actionSheet showInView:self.view];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [menuActions count] ) return; // it's the cancel button
    
    if([menuActions[buttonIndex] objectForKey:@"segue"] != nil) {
        [self performSegueWithIdentifier:[menuActions[buttonIndex] objectForKey:@"segue"] sender:self];
    }
    
    if ([[menuActions[buttonIndex] objectForKey:@"action"] isEqualToString:@"claimBusinessMember"]) {
        [BusinessMemberClaim createWithBusiness:self.business.id
                                        success:^{
                                            NSLog(@"Business member claim successfully created");
                                            HairfieNotifications *notif = [HairfieNotifications new];
                                            [notif showNotificationWithMessage:NSLocalizedStringFromTable(@"Business member successfully claimed", @"Salon_Detail", nil) ForDuration:2.5];
                                        }
                                        failure:^(NSError *error) {
                                            NSLog(@"Failed to claim business member: %@", error.localizedDescription);
                                            HairfieNotifications *notif = [HairfieNotifications new];
                                            [notif showNotificationWithMessage:NSLocalizedStringFromTable(@"Failed to claim business member", @"Salon_Detail", nil) ForDuration:2.5];
                                        }];
    }
}

-(void)claimExistingBusiness {
    [self performSegueWithIdentifier:@"claimExisting" sender:self];
}

-(void)showBusinessMap:(NSNotification*)notification {

    [self performSegueWithIdentifier:@"showMapFromSalon" sender:self];
}

-(void)showTimetable:(NSNotification*)notification {
    
    [self performSegueWithIdentifier:@"showTimetable" sender:self];
}


-(void)showNotLoggedIn:(NSNotification*)notification {
    
    [self showNotLoggedAlertWithDelegate:nil andTitle:nil andMessage:nil];
}

-(void)showMoreReviews:(NSNotification*)notification {

    [self performSegueWithIdentifier:@"showReviews" sender:self];
    isReviewing = NO;
}

-(void)showSimilarBusiness:(NSNotification*)notification {

     NSDictionary* userInfo = notification.userInfo;
    
    similarBusiness = [userInfo objectForKey:@"similarPicked"];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BusinessViewController *similarVC = [storyboard instantiateViewControllerWithIdentifier:@"BusinessDetail"];
    similarVC.business = similarBusiness;
    [self.navigationController pushViewController:similarVC animated:YES];
    
}

-(void)showBusinessDetails:(NSNotification*)notification {
    isDetailsTab = YES;
    isHairfiesTab = NO;
    isServicesTab = NO;
    isHairdressersTab = NO;
    [self.collectionView reloadData];
}

-(void)showBusinessHairfies:(NSNotification*)notification {
    isHairfiesTab = YES;
    isDetailsTab = NO;
    isServicesTab = NO;
    isHairdressersTab = NO;
    [self.collectionView reloadData];
}

-(void)showBusinessHairdressers:(NSNotification*)notification {
    isHairdressersTab = YES;
    isHairfiesTab = NO;
    isDetailsTab = NO;
    isServicesTab = NO;
    [self.collectionView reloadData];
}

-(void)showBusinessServices:(NSNotification*)notification {
    isServicesTab = YES;
    isHairdressersTab = NO;
    isHairfiesTab = NO;
    isDetailsTab = NO;
    [self.collectionView reloadData];
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupHairfies
{
    businessHairfies = [[NSMutableArray alloc] init];
    endOfHairfies = NO;
    loadingHairfies = NO;
    
    [self loadHairfies];
}

-(void)loadHairfies
{
    if (endOfHairfies || loadingHairfies) return;
    
    NSLog(@"Loading next hairfies");
    
    NSDate *until = nil;
    if (businessHairfies.count > 0) {
        until = [businessHairfies[0] createdAt];
    }
    
    loadingHairfies = YES;
    
    [Hairfie listLatestByBusiness:self.business.id
                            until:until
                            limit:[NSNumber numberWithInt:HAIRFIES_PAGE_SIZE]
                             skip:[NSNumber numberWithLong:businessHairfies.count]
                          success:^(NSArray *results) {
                              NSLog(@"Got hairfies");
                              
                              if (results.count < HAIRFIES_PAGE_SIZE) {
                                  NSLog(@"End of hairfies detected");
                                  endOfHairfies = YES;
                              }
                              
                              for (Hairfie *result in results) {
                                  if (![businessHairfies containsObject:result]) {
                                      [businessHairfies addObject:result];
                                  }
                              }
                              
                            [self.collectionView reloadData];
                              
                              loadingHairfies = NO;
                          }
                          failure:^(NSError *error) {
                              NSLog(@"%@", error.localizedDescription);
                              loadingHairfies = NO;
                          }];
}

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (isDetailsTab == YES) {
        return 1;
    }
    
    if (isHairdressersTab == YES) {
        return self.business.activeHairdressers.count + 1;
    }
    
    if (isServicesTab == YES) {
        if (self.business.services.count != 0)
            return self.business.services.count;
        else
            return 1;

    }
    
    if (isHairfiesTab == YES) {
        return businessHairfies.count + 2;
    }

    return 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (isHairfiesTab == YES) {
        return UIEdgeInsetsMake(10, 10, 0, 10);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (isHairfiesTab == YES) {
        return 10;
    }

    return 0;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = nil;
    
    BusinessReusableView *userHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"businessHeaderView" forIndexPath:indexPath];
    
    if (!isSetup) {
        headerViewController = [[SalonDetailHeaderViewController alloc] initWithNibName:@"SalonDetailHeaderViewController" bundle:nil];
        headerViewController.business = self.business;
        UIView *headerView = headerViewController.view;
        
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicturesGallery:)];
        [singleTap setNumberOfTapsRequired:1];
        [userHeader addGestureRecognizer:singleTap];
        
        UISwipeGestureRecognizer* swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPicturesGallery:)];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
        [userHeader addGestureRecognizer:swipeDown];


        [headerView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220)]; // can we use auto-layout instead?
        [userHeader addSubview:headerView];
        
        isSetup = YES;
    }
   
   
    [userHeader setupView];
    headerView = userHeader;
    return headerView;
    
}

-(void) restrictRotation:(BOOL) restriction
{
    appDelegate.restrictRotation = restriction;
}

-(void)showPicturesGallery:(UIGestureRecognizer*)gesture
{
    NSMutableArray* photosUrl = [[NSMutableArray alloc] init];

    
    for (Picture *pic in self.business.pictures)
    {
        IDMPhoto *photo = [[IDMPhoto alloc] initWithURL:pic.url];
        [photosUrl addObject:photo];
    }
  
    
    BusinessPictureGalleryViewController *browser = [[BusinessPictureGalleryViewController alloc]initWithPhotos:photosUrl];
    browser.delegate = self;
    browser.displayActionButton = NO;
    [self presentViewController:browser animated:YES completion:nil];
}


-(void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index
{
    [self restrictRotation:YES];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}





-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = collectionView.bounds.size.width;
    
    if (isHairdressersTab == YES) {
        return CGSizeMake(width, 60);
    } else if (isServicesTab == YES) {
        return CGSizeMake(width, 45);
    } else if (isDetailsTab == YES) {
        return CGSizeMake(width, 964);
    } else if (isHairfiesTab == YES) {
        if (indexPath.row == 0)
            return CGSizeMake(width - 20, 50);
        if (indexPath.row < (businessHairfies.count + 1)) {
            return CGSizeMake((width - 30) / 2, 210);
        } else {
            return CGSizeMake(width, 58);
        }
    }  else {
        return CGSizeMake(width, 127);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isServicesTab == YES) {
        return [self serviceCellForItemAtIndexPath:indexPath];
    } else if (isHairdressersTab == YES) {
        return [self hairdresserCellForItemAtIndexPath:indexPath];
    } else if (isDetailsTab == YES) {
        return [self detailCellAtIndexPath:indexPath];
    } else if (isHairfiesTab == YES) {
        if (indexPath.row == 0) {
            return [self newHairfieCellForItemAtIndexPath:indexPath];
        }
        else if (indexPath.row < (businessHairfies.count + 1)) {
            if (indexPath.row >= (businessHairfies.count - HAIRFIES_PAGE_SIZE + 1)) {
                [self loadHairfies];
            }
            return [self hairfieCellAtIndexPath:indexPath];
        } else {
            return [self loadingCellAtIndexPath:indexPath];
        }
    }

    return nil;
}

-(UICollectionViewCell *)serviceCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessServicesCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"businessServiceCell" forIndexPath:indexPath];
    
    if (self.business.services.count == 0) {
        [cell initWithoutData];
    } else {
        Service *service = [self.business.services objectAtIndex:indexPath.row];
        [cell setService:service];
    }
    
    return cell;
}

-(UICollectionViewCell *)hairdresserCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessHairdressersCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"businessHairdresserCell" forIndexPath:indexPath];
    
    if (indexPath.row < self.business.activeHairdressers.count) {
        BusinessMember *businessMember = [self.business.activeHairdressers objectAtIndex:indexPath.row];
        cell.disclosureIndicator.hidden = YES;
        cell.businessMemberPicture.hidden = NO;
        NSLog(@"business members %@", [businessMember toDictionary]);
        
        [cell setBusinessMember:businessMember];
        
        
    } else if (indexPath.row == self.business.activeHairdressers.count) {
        [cell.businessMemberName setText:NSLocalizedStringFromTable(@"No Hairdresser", @"Salon_Detail", nil)];
        cell.businessMemberPicture.hidden = YES;
        cell.businessMemberName.leftViewMode = UITextFieldViewModeNever;
         cell.disclosureIndicator.hidden = NO;
    }
    return cell;
}

-(UICollectionViewCell *)newHairfieCellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewHairfieCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NEW_HAIRFIE_CELL_IDENTIFIER forIndexPath:indexPath];
    
    return cell;
}

-(UICollectionViewCell *)detailCellAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessDetailCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DETAILS_CELL forIndexPath:indexPath];
    
    [cell setupDetails:self.business];
    
    return cell;
}

-(UICollectionViewCell *)loadingCellAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL forIndexPath:indexPath];
    
    if (endOfHairfies) {
        [cell showEndOfScroll];
    }
    
    return cell;
}

-(UICollectionViewCell *)hairfieCellAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:HAIRFIE_CELL
                                                                                    forIndexPath:indexPath];
    

    [cell setHairfie:businessHairfies[indexPath.item - 1]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isHairfiesTab == YES) {
        if (indexPath.row == 0) {
            [self checkIfCameraDisabled];
        } else {
            hairfie = [businessHairfies objectAtIndex:(indexPath.row - 1)];
            if (hairfie.selfMade == YES)
                NSLog(@"TRUE");
            else
                NSLog(@"FALSE");
            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
            [self performSegueWithIdentifier:@"hairfieDetail" sender:self];
        }
    } else if (isHairdressersTab == YES) {
        if (self.business.activeHairdressers.count != 0) {
            if (indexPath.row == self.business.activeHairdressers.count) {
                [self performSegueWithIdentifier:@"suggestHairdresser" sender:self];
            } else {
                businessMemberPicked = [self.business.activeHairdressers objectAtIndex:indexPath.row];
                [self performSegueWithIdentifier:@"showHairdresserDetail" sender:self];
            }
        } else {
            [self performSegueWithIdentifier:@"suggestHairdresser" sender:self];
        }
    }
}

-(void)checkIfCameraDisabled
{
    __block BOOL isChecked = NO;
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (isChecked == NO) {
        [self performSegueWithIdentifier:@"postHairfie" sender:self];
            isChecked = YES;
        }
    } failureBlock:^(NSError *error) {
        if (error.code == ALAssetsLibraryAccessUserDeniedError) {
            NSLog(@"user denied access : %@",error.description);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Warning",@"Claim", nil) message:NSLocalizedStringFromTable(@"authorized access to camera", @"Post_Hairfie", nil) delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
        }else{
            NSLog(@"Other error code: %zi",error.code);
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"similarBusiness"]) {
        BusinessViewController *bus = segue.destinationViewController;
        bus.business = similarBusiness;
    }
    
    if ([segue.identifier isEqualToString:@"hairfieDetail"]) {
        HairfieDetailViewController *hairfieDetail = segue.destinationViewController;
        hairfieDetail.hairfie = hairfie;
    }
    
    if ([segue.identifier isEqualToString:@"showReviews"]) {
        ReviewsViewController *vc = [segue destinationViewController];
        vc.business = self.business;
    }

    if ([segue.identifier isEqualToString:@"showMapFromSalon"]){
        SalonMapViewController *salonMap = [segue destinationViewController];
        salonMap.business = self.business;
    }
    
    if ([segue.identifier isEqualToString:@"showTimetable"]) {
        HorairesViewController *horaires = [segue destinationViewController];
        horaires.timetable = self.business.timetable;
    }
    
    if ([segue.identifier isEqualToString:@"showHairdresserDetail"]) {
        BusinessMemberViewController *vc = [segue destinationViewController];
        vc.businessMember = businessMemberPicked;
        vc.business = self.business;
    }

    if ([segue.identifier isEqualToString:@"postHairfie"]) {
        appDelegate.hairfieUploader.hairfiePost = [[HairfiePost alloc] initWithBusiness:self.business];
    }
    if ([segue.identifier isEqualToString:@"editOwnedBusiness"]) {
        FinalStepViewController *finalStepVc = [segue destinationViewController];
        
        finalStepVc.isSegueFromBusinessDetail = YES;
        finalStepVc.businessToManage = self.business;
    }
    if ([segue.identifier isEqualToString:@"claimExisting"]) {
        BusinessClaimExistingViewController *controller = [segue destinationViewController];
        controller.business = self.business;
    }
}

@end
