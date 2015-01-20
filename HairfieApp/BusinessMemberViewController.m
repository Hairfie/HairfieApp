//
//  BusinessMemberViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/25/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "BusinessMemberViewController.h"

#import "BusinessMemberReusableView.h"
#import "LoadingCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "DetailsCollectionViewCell.h"
#import "HairfieDetailViewController.h"
#import "AppDelegate.h"
#import "Hairfie.h"
#import "NotLoggedAlert.h"
#import "HairfieNotifications.h"

#define HAIRFIE_CELL @"hairfieCell"
#define LOADING_CELL @"loadingCell"
#define DETAIL_CELL @"detailCell"

@implementation BusinessMemberViewController
{
    BOOL isHairfiesTab;
    BOOL loadingNext;
    BOOL endOfScroll;
    NSMutableArray *hairfies;
    Hairfie *hairfiePicked;
    NSInteger hairfiesCount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showDetails:)
                                                 name:@"detailsTab"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showHairfies:)
                                                 name:@"hairfiesTab"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addToFavorite:)
                                                 name:@"addFavorite"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeFromFavorite:)
                                                 name:@"removeFavorite"
                                               object:nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:HAIRFIE_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:LOADING_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailsCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:DETAIL_CELL];

    isHairfiesTab = NO;
    
    hairfies = [[NSMutableArray alloc] init];
    endOfScroll = NO;
    [self loadHairfies];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    // lazy load business
    if (nil == self.business) {
        [self loadBusiness];
        self.business = self.businessMember.business; // temporary use values from partial object
    }
}

-(void)setBusiness:(Business *)business
{
    _business = business;
    
    [self.collectionView reloadData];
}

-(void)addToFavorite:(NSNotification*)notification
{
  
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = delegate.currentUser;
    
    if ([delegate.credentialStore isLoggedIn]) {
        [User addBusinessMember:self.businessMember.id
              toFavoritesOfUser:currentUser.id
                        success:^() {
                            HairfieNotifications *notif = [HairfieNotifications new];
                            [notif showNotificationWithMessage:NSLocalizedStringFromTable(@"Hairdresser Fav", @"Salon_Detail", nil)
                                                   ForDuration:2.5];
                        }
                        failure:^(NSError *error) {
                            NSLog(@"Failed to add to favorites: %@", error.localizedDescription);
                        }];
    } else {
        [self showNotLoggedAlertWithDelegate:nil andTitle:nil andMessage:nil];
    }
}

-(void)removeFromFavorite:(NSNotification*)notification
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = delegate.currentUser;
    
    if ([delegate.credentialStore isLoggedIn]) {
        [User removeBusinessMember:self.businessMember.id
               fromFavoritesOfUser:currentUser.id
                           success:^{}
                           failure:^(NSError *error) {
                               NSLog(@"Failed to remove from favorites: %@", error.localizedDescription);
                           }];

   } else {
       [self showNotLoggedAlertWithDelegate:nil andTitle:nil andMessage:nil];
   }

}

-(void)showDetails:(NSNotification*)notification
{
    isHairfiesTab = NO;
    [self.collectionView reloadData];
}


-(void)showHairfies:(NSNotification*)notification
{
    isHairfiesTab = YES;
    [self.collectionView reloadData];
}

-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadBusiness
{
    [Business getById:self.businessMember.business.id
          withSuccess:^(Business *business) {
              self.business = business;
          }
              failure:^(NSError *error) {
                  NSLog(@"Failed to load business: %@", error.localizedDescription);
              }];
}
         
-(void)loadHairfies
{
    if (endOfScroll || loadingNext) return;
    
    
    NSDate *until = nil;
    if (hairfies.count > 0) {
        until = [hairfies[0] createdAt];
    }
    
    loadingNext = YES;
    
    [Hairfie listLatestByBusinessMember:self.businessMember.id
                                  limit:[NSNumber numberWithInt:HAIRFIES_PAGE_SIZE]
                                   skip:[NSNumber numberWithLong:hairfies.count]
                                success:^(NSArray *results) {
                                    if (results.count < HAIRFIES_PAGE_SIZE) {
                                        endOfScroll = YES;
                                    }
                             
                                    for (Hairfie *result in results) {
                                        if (![hairfies containsObject:result]) {
                                            [hairfies addObject:result];
                                        }
                                    }
                                    
                                    hairfiesCount = hairfies.count;
                                    [self.collectionView reloadData];
                                    
                                    loadingNext = NO;
                                }
                                failure:^(NSError *error) {
                                    NSLog(@"Failed to load next hairfies: %@", error.localizedDescription);
                                    loadingNext = NO;
                                }];
}


// COLLECTION VIEW FUNCS

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (isHairfiesTab) {
        return hairfies.count + 1;
    }

    return 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (isHairfiesTab)
        return UIEdgeInsetsMake(10 , 10, 0, 10);
    return UIEdgeInsetsMake(0 , 0, 0, 0);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = nil;
    
    BusinessMemberReusableView *businessMemberHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"businessMemberReusableView" forIndexPath:indexPath];
    
    
    businessMemberHeader.businessMember = self.businessMember;
    businessMemberHeader.business = self.business;
    businessMemberHeader.hairfiesCount = hairfiesCount;
  
    [businessMemberHeader setupView];
    
    
    headerView = businessMemberHeader;
    
    return headerView;
    
}




-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isHairfiesTab == YES) {
        if (indexPath.row < hairfies.count) {
            return CGSizeMake(145, 210);
        } else {
            
            return CGSizeMake(300, 58);
        }
    }
    else
        return CGSizeMake(320, 134);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isHairfiesTab == YES) {
        if (indexPath.row < hairfies.count) {
            //load more hairfies?
            if (indexPath.row == (hairfies.count - HAIRFIES_PAGE_SIZE + 1)) {
                [self loadHairfies];
            }
            return [self hairfieCellAtIndexPath:indexPath];
        }
        return [self loadingCellAtIndexPath:indexPath];
    } else {
        return [self hairdresserDetailsCellAtIndexPath:indexPath];
    }
}

-(UICollectionViewCell *)hairdresserDetailsCellAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DETAIL_CELL forIndexPath:indexPath];
    
    
    [cell setBusiness:self.business];
    
    return cell;
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
    Hairfie *hairfie = (Hairfie *)[hairfies objectAtIndex:indexPath.item];
    
    [cell setHairfie:hairfie];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   if (isHairfiesTab == YES)
   {
       hairfiePicked = [hairfies objectAtIndex:indexPath.item];
       [self performSegueWithIdentifier:@"showHairfieDetail" sender:self];
   }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(320, 324);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showHairfieDetail"])
    {
        HairfieDetailViewController *hairfieDetail = segue.destinationViewController;
        
        
        hairfieDetail.hairfie = hairfiePicked;
    }
}

@end
