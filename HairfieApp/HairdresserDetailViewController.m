//
//  HairdresserDetailViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 11/25/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import "HairdresserDetailViewController.h"

#import "HairdresserReusableView.h"
#import "LoadingCollectionViewCell.h"
#import "CustomCollectionViewCell.h"
#import "DetailsCollectionViewCell.h"

#import "Hairfie.h"

@interface HairdresserDetailViewController ()

@end

#define HAIRFIE_CELL @"hairfieCell"
#define LOADING_CELL @"loadingCell"
#define DETAIL_CELL @"detailCell"

@implementation HairdresserDetailViewController
{
    BOOL isHairfiesTab;
    BOOL loadingNext;
    BOOL endOfScroll;
    NSMutableArray *hairdresserHairfies;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:HAIRFIE_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:LOADING_CELL];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailsCollectionViewCell" bundle:nil]forCellWithReuseIdentifier:DETAIL_CELL];

    isHairfiesTab = NO;
    
    [self getHairdresserHairfies];
    // Do any additional setup after loading the view.
}


-(IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getHairdresserHairfies
{
    hairdresserHairfies = [[NSMutableArray alloc] init];
    endOfScroll = NO;
    [self loadHairfies];
}

-(void)loadHairfies
{
    if (endOfScroll || loadingNext) return;
    
    
    NSDate *until = nil;
    if (hairdresserHairfies.count > 0) {
        until = [hairdresserHairfies[0] createdAt];
    }
    
    loadingNext = YES;
    
    [Hairfie getHairfiesByAuthor:self.hairdresser.id
                           until:until
                           limit:[NSNumber numberWithInt:HAIRFIES_PAGE_SIZE]
                            skip:[NSNumber numberWithLong:hairdresserHairfies.count]
                         success:^(NSArray *results) {
                             
                             if (results.count < HAIRFIES_PAGE_SIZE) {
                                 endOfScroll = YES;
                                 
                             }
                             
                             for (Hairfie *result in results) {
                                 if (![hairdresserHairfies containsObject:result]) {
                                     [hairdresserHairfies addObject:result];
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


// COLLECTION VIEW FUNCS

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    if (isHairfiesTab)
        return hairdresserHairfies.count + 1;
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
    
    HairdresserReusableView *hairdresserHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hairdresserReusableView" forIndexPath:indexPath];
    
    
    hairdresserHeader.business = self.business;
    [hairdresserHeader setupView];
    
    
    headerView = hairdresserHeader;
    
    return headerView;
    
}




-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isHairfiesTab == YES) {
        if (indexPath.row < hairdresserHairfies.count) {
            return CGSizeMake(145, 210);
        } else {
            
            return CGSizeMake(300, 58);
        }
    }
    else
        return CGSizeMake(320, 234);
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (isHairfiesTab == YES) {
        if (indexPath.row < hairdresserHairfies.count) {
            //load more hairfies?
            if (indexPath.row == (hairdresserHairfies.count - HAIRFIES_PAGE_SIZE + 1)) {
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
    
    
    [cell setupCell:self.business];
    
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
    Hairfie *hairfie = (Hairfie *)[hairdresserHairfies objectAtIndex:indexPath.item];
    [cell setHairfie:hairfie];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(320, 275);
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
