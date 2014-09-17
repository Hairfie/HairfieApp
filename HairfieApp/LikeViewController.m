//
//  LikeViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 29/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "LikeViewController.h"
#import "AppDelegate.h"
#import "CustomCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"
#import "HairfieDetailViewController.h"
#import "User.h"

@interface LikeViewController ()
{
    User *currentUser;
    NSMutableArray *
    hairfies;
    BOOL loadingNext;
    BOOL endOfScroll;
}
@end

@implementation LikeViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addGestureRecognizer:self.slidingViewController.panGesture];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"hairfieCell"];

    [self.collectionView registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"loadingCell"];

    currentUser = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];
    loadingNext = NO;

    if (nil != currentUser) {
        [self refreshHairfies];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshHairfies
{
    // (re)initialize hairfies list
    hairfies = [[NSMutableArray alloc] init];
    endOfScroll = NO;

    // fetch first page of hairfies
    [self loadNextHairfies];
}


-(void)loadNextHairfies
{
    if (loadingNext || endOfScroll) {
        return;
    }

    loadingNext = YES;

    void (^successHandler)(NSArray *) = ^(NSArray *results) {
        for (Hairfie *result in results) {
            if (![hairfies containsObject:result]) {
                [hairfies addObject:result];
            }
        }
        
        [self.collectionView reloadData];
        
        // did we reach the end of scroll?
        if (results.count < HAIRFIES_PAGE_SIZE) {
            endOfScroll = YES;
        }

        loadingNext = NO;
    };

    void (^failureHandler)(NSError *) = ^(NSError *error) {
        NSLog(@"Failed to fetch next hairfies: %@", error.localizedDescription);
        loadingNext = NO;
    };

    NSDate *until = nil;
    if (hairfies.count > 0) {
        until = [[hairfies objectAtIndex:0] createdAt];
    }

    [User listHairfiesLikedByUser:currentUser.id
                            until:until
                            limit:[NSNumber numberWithInt:HAIRFIES_PAGE_SIZE]
                             skip:[NSNumber numberWithLong:hairfies.count]
                          success:successHandler
                          failure:failureHandler];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"hairfieDetail" sender:hairfies[indexPath.row]];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return hairfies.count + 1; // +1 for the loading cell
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < hairfies.count) {
        return CGSizeMake(145, 210);
    } else {
        return CGSizeMake(300, 58);
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < hairfies.count) {
        // load more hairfies?
        if (indexPath.row == hairfies.count - HAIRFIES_PAGE_SIZE + 1) {
            [self loadNextHairfies];
        }
        
        return [self hairfieCellAtIndexPath:indexPath];
    }
    
    return [self loadingCellAtIndexPath:indexPath];
}

-(UICollectionViewCell *)hairfieCellAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"hairfieCell"
                                                                                    forIndexPath:indexPath];

    [cell setHairfie:hairfies[indexPath.row]];

    return cell;
}

-(UICollectionViewCell *)loadingCellAtIndexPath:(NSIndexPath *)indexPath
{
    LoadingCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"loadingCell"
                                                                                     forIndexPath:indexPath];

    if (endOfScroll) {
        [cell showEndOfScroll];
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"hairfieDetail"]) {
        HairfieDetailViewController *controller = [segue destinationViewController];
        controller.currentHairfie = sender;
    }
}

@end
