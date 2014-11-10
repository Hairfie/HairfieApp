//
//  UserProfileViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 10/22/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Hairfie.h"
#import "BusinessReview.h"
#import "AppDelegate.h"
#import "UIButton+Style.h"
#import "UILabel+Style.h"
#import "Picture.h"
#import "UIRoundImageView.h"
#import "UIImage+Filters.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"
#import "ReviewTableViewCell.h"
#import "HairfieDetailViewController.h"
#import "CameraOverlayViewController.h"

#define HAIRFIE_CELL @"hairfieCell"
#define LOADING_CELL @"loadingCell"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
{
    AppDelegate *appDelegate;
    UIImageView *userProfilePicture;
    NSMutableArray *userHairfies;
    NSMutableArray *userReviews;
    BOOL loadingNext;
    BOOL endOfScroll;
    NSNumber *currentPage;
    NSInteger hairfieRow;
    Picture *uploadedPicture;
    BOOL uploadInProgress;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainScrollView.delegate = self;
   // self.bottomMenuBttn.hidden = YES;
    
    self.hairfiesCollection.delegate = self;
    self.hairfiesCollection.dataSource = self;
   
    [self.hairfiesCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:HAIRFIE_CELL];
    [self.hairfiesCollection registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:LOADING_CELL];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self setButtonSelected:self.hairfieBttn];

    loadingNext = NO;
    
    if (nil != self.user) {
        [self setupHairfies];
          }

    [self initKnownData];

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    
  // CHANGED PIC //
    
   // if (self.imageFromSegue != nil)
    //    [self uploadProfileImage:self.imageFromSegue];
}

// Changed pic = > upload and then modify current user with new picture object

-(void) uploadProfileImage:(UIImage *)image
{
    uploadInProgress = YES;
    Picture *imagePost = [[Picture alloc] initWithImage:image andContainer:@"user-profile-pictures"];
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        uploadInProgress = NO;
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSDictionary*) = ^(NSDictionary* result){
       
        
        // modify user.picture to new Picture* object
        
        self.user.picture = imagePost;
        
        //
        
        uploadInProgress = NO;
        
        void (^loadErrorBlock)(NSError *) = ^(NSError *error){
            NSLog(@"Error : %@", error.description);
        };
        void (^loadSuccessBlock)(void) = ^(void){
       
            // Setup header pictures (profile + bg)
            
         [self setupHeaderPictures];
            NSLog(@"ici");
        };
        
        [self.user saveWithSuccess:loadSuccessBlock failure:loadErrorBlock];
       
    };
    
    [imagePost uploadWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}




-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setupHeaderPictures
{
    
    NSLog(@"user pic %@", self.user.picture.url);
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    
    [manager downloadImageWithURL:[NSURL URLWithString:self.user.picture.url]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
     {
         if (image)
         {
             self.backgroundProfilePicture.image = [image applyLightEffect];
         }
     }];
    
    userProfilePicture = [[UIRoundImageView alloc] initWithFrame:CGRectMake(118, 48, 84, 84)];
    userProfilePicture.clipsToBounds = YES;
    userProfilePicture.contentMode = UIViewContentModeScaleAspectFit;
    
    [userProfilePicture sd_setImageWithURL:[NSURL URLWithString:[self.user pictureUrlwithWidth:@200 andHeight:@200]]
                          placeholderImage:[UIColor imageWithColor:[UIColor lightGreyHairfie]]];
    
    UIView *profileBorder =[[UIView alloc] initWithFrame:CGRectMake(113, 43, 94, 94)];
    profileBorder.layer.cornerRadius = profileBorder.frame.size.height / 2;
    profileBorder.clipsToBounds = YES;
    profileBorder.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    [self.topView addSubview:profileBorder];
    [self.topView addSubview:userProfilePicture];
}




-(void) initKnownData
{
    
    [self setupHairfies];
    [self setupHeaderPictures];
    [self updateHairfieView];
    
    if (self.isCurrentUser == YES) {
        self.navBttn.hidden = YES;
        self.leftMenuBttn.hidden = NO;
    } else {
        self.navBttn.hidden = NO;
        self.leftMenuBttn.hidden = YES;
    }
    
    userReviews= [[NSMutableArray alloc] init];
    [self getReviews];
    
    [self.followUserBttn setTitle:NSLocalizedStringFromTable(@"Follow", @"UserProfile", nil) forState:UIControlStateNormal];
    [self.followUserBttn profileFollowStyle];
   
    
    [self.userName profileUserNameStyle];
    self.userName.text = self.user.name;
    [self.hairfieBttn profileTabStyle];
    [self.hairfieBttn setTitle:[NSString stringWithFormat:@"%@", self.user.numHairfies] forState:UIControlStateNormal];

    [self.reviewBttn profileTabStyle];
    [self.reviewBttn setTitle:[NSString stringWithFormat:@"%@", self.user.numBusinessReviews] forState:UIControlStateNormal];

    self.reviewLbl.text = NSLocalizedStringFromTable(@"Reviews", @"UserProfile", nil);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  
}

-(IBAction)showMenuActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"Salon_Detail", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    
    
    [actionSheet addButtonWithTitle:NSLocalizedStringFromTable(@"change picture", @"User_Profile", nil)];
  
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) return; // it's the cancel button
    else
        [self addPicture];
}

-(void)addPicture
{
    [self performSegueWithIdentifier:@"cameraOverlaytest" sender:self];
}



-(IBAction)changeTab:(id)sender
{
    [self setButtonSelected:sender];
}

-(void)setButtonSelected:(UIButton*)aButton
{
    self.hairfieView.hidden = YES;
    self.reviewView.hidden = YES;
    UIView *bottomBorder = [[UIView alloc] init];
    
    if (aButton == self.hairfieBttn) {
        self.hairfieView.hidden = NO;
        [bottomBorder setFrame:CGRectMake(0, aButton.frame.size.height, aButton.frame.size.width - 1, 3)];
        
        if (userHairfies.count % 2 == 1)
            self.mainViewHeight.constant = ((userHairfies.count / 2 + 1) * 220)+ 274 + 68;
        else
            self.mainViewHeight.constant = ((userHairfies.count / 2) * 220)+ 274 + 68;
    }
    if (aButton == self.reviewBttn)
    {
         [bottomBorder setFrame:CGRectMake(1, aButton.frame.size.height, aButton.frame.size.width, 3)];
        self.reviewView.hidden = NO;
        self.mainViewHeight.constant = (userReviews.count * 130) + 274;
    }
    
    for (UIButton *btn in @[self.hairfieBttn, self.reviewBttn]) {
        for (UIView *subView in btn.subviews) {
            if (subView.tag == 1) [subView removeFromSuperview];
        }
    }
    
    bottomBorder.backgroundColor = [UIColor salonDetailTab];
    bottomBorder.tag = 1;
    [aButton addSubview:bottomBorder];
    
}
-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return userHairfies.count + 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < userHairfies.count) {
        return CGSizeMake(145, 210);
    } else {
        return CGSizeMake(300, 58);
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < userHairfies.count) {
        // load more hairfies?
        if (indexPath.row == (userHairfies.count - HAIRFIES_PAGE_SIZE + 1)) {
            [self loadHairfies];
        }
        return [self hairfieCellAtIndexPath:indexPath];
    }
    return [self loadingCellAtIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"clicked at index :%d", indexPath.item);
    hairfieRow = indexPath.item;
    [self performSegueWithIdentifier:@"hairfieDetailtest" sender:self];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"DESELECT HAIRFIE");
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"should clicked at index :%d", indexPath.item);
    return YES;
}


-(UICollectionViewCell *)hairfieCellAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [self.hairfiesCollection dequeueReusableCellWithReuseIdentifier:HAIRFIE_CELL
        forIndexPath:indexPath];
    
    
    Hairfie *hairfie = (Hairfie *)[userHairfies objectAtIndex:indexPath.item];
    [cell setHairfie:hairfie];
    
    return cell;
}

-(UICollectionViewCell *)loadingCellAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCollectionViewCell *cell = [self.hairfiesCollection dequeueReusableCellWithReuseIdentifier:LOADING_CELL
        forIndexPath:indexPath];
    
    if (endOfScroll) {
        [cell showEndOfScroll];
    }
    
    return cell;
}


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
                             
                            
                             [self updateHairfieView];
                         
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


-(void)updateHairfieView
{
    if (userHairfies.count % 2 == 1)
        self.mainViewHeight.constant = (((userHairfies.count / 2) + 1) * 220)+ 274 + 68;
    else
        self.mainViewHeight.constant = ((userHairfies.count / 2) * 220)+ 274 + 68;
    
   self.collectionViewHeight.constant = (((userHairfies.count / 2 ) + 1) * 220) + 168;
    
    [self.hairfiesCollection reloadData];

}

-(void)getReviews
{
    
    void (^successHandler)(NSArray *) = ^(NSArray *results) {
        userReviews = [NSMutableArray arrayWithArray:results];
        self.mainViewHeight.constant = (userReviews.count * 130) + 274;
        self.tableViewHeight.constant = (userReviews.count * 130);
        [self.reviewTableView reloadData];
    };
    
    void (^failureHandler)(NSError *) = ^(NSError *error) {
        NSLog(@"Failed to get user's reviews");
    };
    
    [BusinessReview listLatestByAuthor:self.user.id success:successHandler failure:failureHandler];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return userReviews.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"reviewCell";
    ReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    BusinessReview *review = (BusinessReview *)[userReviews objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor whiteColor];
   
    if (tableView == self.reviewTableView)
        [cell setReview:review];
    
    return cell;
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"hairfieDetailtest"]) {
        HairfieDetailViewController *vc = (HairfieDetailViewController *)segue.destinationViewController;
        vc.hairfie = (Hairfie*)[userHairfies objectAtIndex:hairfieRow];
    }
    if ([segue.identifier isEqualToString:@"cameraOverlaytest"])
    {
        CameraOverlayViewController *camera = [segue destinationViewController];
        camera.isProfile = YES;
        camera.user = self.user;
    }
}



@end
