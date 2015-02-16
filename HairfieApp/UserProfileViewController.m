//
//  UserProfileViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/19/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "AppDelegate.h"
#import "BusinessReview.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserProfileViewController.h"
#import "LoadingCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "ReviewsCollectionViewCell.h"
#import "NoReviewCollectionViewCell.h"
#import "UserProfileReusableView.h"
#import "HairfieDetailViewController.h"
#import "CameraOverlayViewController.h"
#import "BusinessViewController.h"
#import "Hairfie.h"
#import "Picture.h"

#define HAIRFIE_CELL @"hairfieCell"
#define LOADING_CELL @"loadingCell"
#define REVIEW_CELL @"reviewCell"
#define NO_REVIEW_CELL @"noReviewCell"

@interface UserProfileViewController ()


@end

@implementation UserProfileViewController
{
    BOOL isHairfiesTab;
    BOOL endOfScroll;
    BOOL loadingNext;
    NSMutableArray *userHairfies;
    NSMutableArray *userReviews;
    AppDelegate *appDelegate;
    NSInteger hairfieRow;
    BOOL uploadInProgress;
    Business *businessPicked;
    BOOL isSetup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showReviews:)
                                                 name:@"reviewsTab"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showHairfies:)
                                                 name:@"hairfiesTab"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshHeader:)
                                                 name:@"pictureUploaded"
                                               object:nil];
    
    isHairfiesTab = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:HAIRFIE_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:LOADING_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ReviewsCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:REVIEW_CELL];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"NoReviewCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:NO_REVIEW_CELL];

    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    loadingNext = NO;
    
    if (nil != self.user) {
        [self setupHairfies];
    }
    
    [self initKnownData];
    
    // Do any additional setup after loading the view.
}


-(IBAction)addPicture:(id)sender
{
    
    if ([appDelegate.currentUser.id isEqualToString:self.user.id]) {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Salon_Detail", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedStringFromTable(@"Change picture", @"UserProfile", nil),nil];
    
    

   
    
    [actionSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) [self checkIfCameraDisabled];
    if (1 == buttonIndex) return; // it's the cancel button
}

-(void)checkIfCameraDisabled
{
    __block BOOL isChecked = NO;
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    
    [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        NSLog(stop ? @"Yes" : @"No");
        if (isChecked == NO) {
            [self performSegueWithIdentifier:@"changeUserPicture" sender:self];
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


-(void)viewWillAppear:(BOOL)animated {
    if (self.imageFromSegue != nil)
        [self uploadProfileImage:self.imageFromSegue];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showReviews:(NSNotification*)notification {
    isHairfiesTab = NO;
    [self.collectionView reloadData];
}

-(void)showHairfies:(NSNotification*)notification {
    isHairfiesTab = YES;
    [self.collectionView reloadData];
}

-(void)refreshHeader:(NSNotification*)notification
{
    [self.collectionView reloadData];
}


-(void) uploadProfileImage:(UIImage *)image
{
    
    uploadInProgress = YES;
    Picture *imagePost = [[Picture alloc] initWithImage:image andContainer:@"user-profile-pictures"];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        uploadInProgress = NO;
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(void) = ^(void){
        
        
        // modify user.picture to new Picture* object
        
        self.user.picture = imagePost;
        
        void (^loadErrorFunc)(NSError *) = ^(NSError *error){
            uploadInProgress = NO;
            NSLog(@"Error : %@", error.description);
        };
        void (^loadSuccessFunc)(void) = ^(void){
            [self.user refresh];
            
        };
        
         uploadInProgress = NO;
       
        [self.user saveWithSuccess:loadSuccessFunc failure:loadErrorFunc];
        
    };
    [imagePost uploadWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}




// INIT DATA

-(void) initKnownData
{
    
    [self setupHairfies];
    
    if (self.isCurrentUser == YES) {
        self.navBttn.hidden = YES;
        self.leftMenuBttn.hidden = NO;
    } else {
        self.navBttn.hidden = NO;
        self.leftMenuBttn.hidden = YES;
    }
    
    userReviews= [[NSMutableArray alloc] init];
    [self getReviews];
}



-(void)getReviews
{
    void (^successHandler)(NSArray *) = ^(NSArray *results) {
        userReviews = [NSMutableArray arrayWithArray:results];
    };
    
    void (^failureHandler)(NSError *) = ^(NSError *error) {
        NSLog(@"Failed to get user's reviews");
    };
    
    [BusinessReview listLatestByAuthor:self.user.id success:successHandler failure:failureHandler];
}



// COLLECTION VIEW DELEGATE / DATA SOURCE

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (isHairfiesTab)
        return userHairfies.count + 1;
    else {
        if (userReviews.count != 0)
            return userReviews.count;
        else
            return 1;
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (isHairfiesTab)
        return UIEdgeInsetsMake(10 , 10, 0, 10);
    return UIEdgeInsetsMake(10 , 10, 0, 10);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = nil;
    
    UserProfileReusableView *userHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"profileHeaderView" forIndexPath:indexPath];
    
    [userHeader setUser:self.user];
   
    
        [userHeader setupView];
    
    
    headerView = userHeader;
    
    return headerView;
    
}




-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isHairfiesTab == YES) {
        if (indexPath.row < userHairfies.count) {
            return CGSizeMake((collectionView.frame.size.width - 30) / 2, 210);
        } else {
            
            return CGSizeMake(collectionView.frame.size.width - 20, 58);
        }
    }
    else
        return CGSizeMake(collectionView.frame.size.width, 138);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isHairfiesTab == YES) {
        if (indexPath.row < userHairfies.count) {
            //load more hairfies?
            if (indexPath.row == (userHairfies.count - HAIRFIES_PAGE_SIZE + 1)) {
                [self loadHairfies];
            }
            return [self hairfieCellAtIndexPath:indexPath];
        }
        return [self loadingCellAtIndexPath:indexPath];
    } else {
        return [self reviewCellAtIndexPath:indexPath];
    }
}


-(UICollectionViewCell *)reviewCellAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewsCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:REVIEW_CELL forIndexPath:indexPath];
     NoReviewCollectionViewCell *noReviewCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NO_REVIEW_CELL forIndexPath:indexPath];
    
    
    
    if (userReviews.count != 0) {
        BusinessReview *review = (BusinessReview *)[userReviews objectAtIndex:indexPath.row];
        [cell setReview:review];
         return cell;
    }
    else
        return noReviewCell;
    
}


-(UICollectionViewCell *)loadingCellAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:LOADING_CELL forIndexPath:indexPath];
    
    if (endOfScroll) {
        [cell showEndOfScroll];
    }

    return cell;
}


-(UICollectionViewCell *)hairfieCellAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:HAIRFIE_CELL
                                                                                        forIndexPath:indexPath];
    Hairfie *hairfie = (Hairfie *)[userHairfies objectAtIndex:indexPath.item];
    [cell setHairfie:hairfie];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    hairfieRow = indexPath.item;
    if (isHairfiesTab == YES)
        [self performSegueWithIdentifier:@"showHairfieDetail" sender:self];
    else
    {
        if (userReviews.count != 0) {
        BusinessReview *businessReview = [userReviews objectAtIndex:indexPath.item];
        [Business getById:businessReview.business.id
              withSuccess:^(Business *business) {
                  businessPicked = business;
                  [self performSegueWithIdentifier:@"showBusinessFromReview" sender:self];
              }
                  failure:^(NSError *error) {
                      NSLog(@"Failed to retrieve complete business: %@", error.localizedDescription);
                  }];
        }
    }
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 324);
}



// HAIRFIE LOADING

-(void)setupHairfies
{
    userHairfies = [[NSMutableArray alloc] init];
    endOfScroll = NO;
    [self loadHairfies];
}


-(void)loadHairfies
{
    if (endOfScroll || loadingNext) return;
    
    
    NSDate *until = nil;
    if (userHairfies.count > 0) {
        until = [userHairfies[0] createdAt];
    }
    
    loadingNext = YES;
    
    [Hairfie getHairfiesByAuthor:self.user.id
                           until:until
                           limit:[NSNumber numberWithInt:HAIRFIES_PAGE_SIZE]
                            skip:[NSNumber numberWithLong:userHairfies.count]
                         success:^(NSArray *results) {
                             
                             if (results.count < HAIRFIES_PAGE_SIZE) {
                                 endOfScroll = YES;
                                 
                             }
                             
                             for (Hairfie *result in results) {
                                 if (![userHairfies containsObject:result]) {
                                     [userHairfies addObject:result];
                                 }
                             }
                             
                             [self.collectionView reloadData];
                             
                             if (results.count < HAIRFIES_PAGE_SIZE) {
                                 NSLog(@"Got %@ harfies instead of %@ asked, we reached the end.", [NSNumber numberWithLong:results.count], [NSNumber numberWithInt:HAIRFIES_PAGE_SIZE]);
                                 endOfScroll = YES;
                             }
                             
                             loadingNext = NO;
                         }
                         failure:^(NSError *error) {
                             NSLog(@"%@", error.localizedDescription);
                             loadingNext = NO;
                        }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showHairfieDetail"]) {
        HairfieDetailViewController *vc = (HairfieDetailViewController *)segue.destinationViewController;
        vc.hairfie = (Hairfie*)[userHairfies objectAtIndex:hairfieRow];
    }
    if ([segue.identifier isEqualToString:@"showBusinessFromReview"]) {
        BusinessViewController *vc = (BusinessViewController*)segue.destinationViewController;
        vc.business = businessPicked;
    }
    if ([segue.identifier isEqualToString:@"changeUserPicture"])
    {
        CameraOverlayViewController *camera = [segue destinationViewController];
        camera.isProfile = YES;
        camera.user = self.user;
    }
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
