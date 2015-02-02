//
//  HairfieContentViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 1/12/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "HairfieContentViewController.h"
#import "CustomCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"


#define CUSTOM_CELL_IDENTIFIER @"hairfieCell"
#define CATEGORY_CELL_IDENTIFIER @"categoryCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"

@interface HairfieContentViewController ()

@end

@implementation HairfieContentViewController {
    NSArray *categoriesNames;
    NSArray *categoriesImages;
    NSNumber *currentPage;
    NSMutableArray *hairfies;
    UIRefreshControl *refreshControl;
    BOOL endOfScroll;
}

- (void)viewDidLoad {

    self.contentCollection.scrollsToTop = YES;
    [super viewDidLoad];
    [self.contentCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CUSTOM_CELL_IDENTIFIER];
     [self.contentCollection registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarTappedAction:)
                                                 name:kStatusBarTappedNotification
                                               object:nil];
    currentPage = @(0);
    hairfies = [[NSMutableArray alloc] init];
    endOfScroll = NO;
    [self getHairfies:nil];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(getHairfiesFromRefresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.contentCollection addSubview:refreshControl];
   
    
    // Do any additional setup after loading the view.
}

- (void)statusBarTappedAction:(NSNotification*)notification {
    [self.contentCollection scrollRectToVisible:CGRectMake(10, 0, self.contentCollection.frame.size.width, self.contentCollection.frame.size.height) animated:YES];
}

-(void)scrollToTop {
}

-(void)viewDidAppear:(BOOL)animated
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:NSLocalizedStringFromTable(@"Hairfies",@"Feed",nil)
                                                     forKey:@"menuItem"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionChanged"
                                                        object:self
                                                      userInfo:dict];
}

-(void)viewWillAppear:(BOOL)animated {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [hairfies count]) {
        return CGSizeMake((collectionView.frame.size.width - 30) / 2, 210);
    } else {
        return CGSizeMake(collectionView.frame.size.width, 58);
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [hairfies count] + 1;
}

// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 5;
}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row < [hairfies count]) {
        if(indexPath.row == ([hairfies count] - HAIRFIES_PAGE_SIZE + 1) && currentPage != 0){
            [self fetchMoreHairfies];
        }
        return [self hairfieCellForIndexPath:indexPath];
    } else {
        return [self loadingCellForIndexPath:indexPath];
    }
}


- (UICollectionViewCell *)hairfieCellForIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = [self.contentCollection dequeueReusableCellWithReuseIdentifier:CUSTOM_CELL_IDENTIFIER forIndexPath:indexPath];
    Hairfie *hairfie = (Hairfie *)[hairfies objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (!hairfies) {
        cell.hairfieView.image = [UIImage imageNamed:@"hairfie.jpg"];
    }
    else {
        [cell setHairfie:hairfie];
    }
    
    return cell;
}

- (UICollectionViewCell *)loadingCellForIndexPath:(NSIndexPath *)indexPath {
    LoadingCollectionViewCell *cell = [self.contentCollection dequeueReusableCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoadingCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(endOfScroll) {
        [cell showEndOfScroll];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Hairfie *hairfie = (Hairfie*)[hairfies objectAtIndex:indexPath.row];
    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:hairfie
                                                     forKey:@"hairfie"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"hairfieSelected"
                                                        object:self
                                                      userInfo:dict];
}





// Get Hairfies Data

-(void)getHairfiesFromRefresh:(UIRefreshControl *)refresh {
    [self getHairfies:nil];
}

-(void)getHairfies:(NSNumber *)page
{
    
    if(page == nil) {
        page = @(0);
    }
    NSNumber *offset = @([page integerValue] * HAIRFIES_PAGE_SIZE);
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
        [refreshControl endRefreshing];
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models){
        if([models count] < HAIRFIES_PAGE_SIZE)
            endOfScroll = YES;
        for (int i = 0; i < models.count; i++) {
            NSNumber *dynamicIndex = @(i + [offset integerValue]);
            if([dynamicIndex integerValue] < [hairfies count]) {
                [hairfies replaceObjectAtIndex:[dynamicIndex integerValue] withObject:models[i]];
            } else {
                [hairfies addObject:models[i]];
            }
        }
        [self customReloadData];
    };
    NSLog(@"Get Hairfies for page : %@", page);
    
    if(!endOfScroll) {
        [Hairfie listLatestPerPage:page
                           success:loadSuccessBlock
                           failure:loadErrorBlock];
    }
}

- (void)fetchMoreHairfies {
    int value = [currentPage intValue];
    currentPage = [NSNumber numberWithInt:value + 1];;
    [self getHairfies:currentPage];
}


- (void)customReloadData
{
    [self.contentCollection reloadData];
    if (refreshControl) {
       [refreshControl endRefreshing];
    }
}

@end
