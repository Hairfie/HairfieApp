//
//  UserProfileViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 10/22/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Hairfie.h"
#import "AppDelegate.h"
#import "UIButton+Style.h"
#import "UILabel+Style.h"
#import "Picture.h"
#import "UIRoundImageView.h"
#import "UIImage+Filters.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
{
    AppDelegate *appDelegate;
    UIImageView *userProfilePicture;
    NSMutableArray *userHairfies;
    BOOL loadingNext;
    BOOL endOfScroll;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.hairfiesCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"hairfieRelated"];
    
    
    [self.hairfiesCollection registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"loadingCell"];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    loadingNext = NO;
    [self setButtonSelected:self.hairfieBttn];
    if (nil != self.user) {
        [self refreshHairfieList];
    }
    // Do any additional setup after loading the view.
}

-(void)refreshHairfieList
{
    // (re)initialize hairfies list
    userHairfies = [[NSMutableArray alloc] init];
    endOfScroll = NO;
    
    // fetch first page of hairfies
    [self loadNextHairfieLikes];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self initKnownData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupHairfies
{
    
    NSDate *until = nil;
    if (userHairfies.count > 0) {
        until = [userHairfies[0] createdAt];
    }

    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        
        NSLog(@"Error : %@", error.description);
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *results) {
        
        userHairfies = [NSMutableArray arrayWithArray:results];
        [self.hairfiesCollection reloadData];
        //  [self performSegueWithIdentifier:@"toSalonDetail" sender:self];
    };
    [Hairfie getHairfiesByAuthor:self.user.id until:nil limit:@HAIRFIES_PAGE_SIZE skip:@0 success:loadSuccessBlock failure:loadErrorBlock];
    
}
-(void) initKnownData
{
    if (self.isCurrentUser == YES) {
        self.navBttn.hidden = YES;
        self.menuBttn.hidden = NO;
    } else {
        self.navBttn.hidden = NO;
        self.menuBttn.hidden = YES;
    }
  //  [self setupHairfies];
    
    [self.followUserBttn setTitle:NSLocalizedStringFromTable(@"Follow", @"UserProfile", nil) forState:UIControlStateNormal];
    [self.followUserBttn profileFollowStyle];
    
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
    
    [self.userName profileUserNameStyle];
    self.userName.text = self.user.name;
    [self.hairfieBttn profileTabStyle];
    [self.reviewBttn profileTabStyle];
    
    self.reviewLbl.text = NSLocalizedStringFromTable(@"Reviews", @"UserProfile", nil);
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
    }
    if (aButton == self.reviewBttn)
    {
         [bottomBorder setFrame:CGRectMake(1, aButton.frame.size.height, aButton.frame.size.width, 3)];
        self.reviewView.hidden = NO;
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
        if (indexPath.row == userHairfies.count - HAIRFIES_PAGE_SIZE + 1) {
            [self loadNextHairfieLikes];
        }

        return [self hairfieCellAtIndexPath:indexPath];
    }
    return [self loadingCellAtIndexPath:indexPath];
}

-(UICollectionViewCell *)hairfieCellAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [self.hairfiesCollection dequeueReusableCellWithReuseIdentifier:@"hairfieCell"
        forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Hairfie *hairfie = (Hairfie *)[userHairfies objectAtIndex:indexPath.row];
    NSLog(@"hairfie : %@", hairfie);
    
    [cell setHairfie:hairfie];
    
    return cell;
}

-(UICollectionViewCell *)loadingCellAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCollectionViewCell *cell = [self.hairfiesCollection dequeueReusableCellWithReuseIdentifier:@"loadingCell"
                                                                                     forIndexPath:indexPath];
    
    if (endOfScroll) {
        [cell showEndOfScroll];
    }
    
    return cell;
}

-(void)loadNextHairfieLikes
{
    if (loadingNext || endOfScroll) {
        return;
    }
    
    loadingNext = YES;
    
    void (^successHandler)(NSArray *) = ^(NSArray *results) {
        for (Hairfie *result in results) {
            if (![userHairfies containsObject:result]) {
                [userHairfies addObject:result];
            }
        }
        
        [self.hairfiesCollection reloadData];
        
        // did we reach the end of scroll?
        if (results.count < HAIRFIES_PAGE_SIZE) {
            NSLog(@"GOT %@ harfies instead of %@ asked, we reached the end.", [NSNumber numberWithLong:results.count], [NSNumber numberWithInt:HAIRFIES_PAGE_SIZE]);
            endOfScroll = YES;
        }
        
        loadingNext = NO;
    };
    
    void (^failureHandler)(NSError *) = ^(NSError *error) {
        NSLog(@"Failed to fetch next hairfies: %@", error.localizedDescription);
        loadingNext = NO;
    };
    
    NSDate *until = nil;
    if (userHairfies.count > 0) {
        
        //until = [[userHairfies objectAtIndex:0] createdAt];
    }
    
    [Hairfie getHairfiesByAuthor:self.user.id until:until limit:@HAIRFIES_PAGE_SIZE skip:[NSNumber numberWithLong:userHairfies.count] success:successHandler failure:failureHandler];
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
