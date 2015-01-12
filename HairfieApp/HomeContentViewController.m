//
//  HomeContentViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 1/12/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "HomeContentViewController.h"
#import "CustomCollectionViewCell.h"
#import "CategoriesCollectionViewCell.h"
#import "LoadingCollectionViewCell.h"


#define CUSTOM_CELL_IDENTIFIER @"hairfieCell"
#define CATEGORY_CELL_IDENTIFIER @"categoryCell"
#define LOADING_CELL_IDENTIFIER @"LoadingItemCell"

@interface HomeContentViewController ()

@end

@implementation HomeContentViewController
{
    NSArray *categoriesNames;
    NSArray *categoriesImages;
    NSNumber *currentPage;
    NSMutableArray *hairfies;
    BOOL endOfScroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.contentCollection registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CUSTOM_CELL_IDENTIFIER];
     [self.contentCollection registerNib:[UINib nibWithNibName:@"CategoriesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CATEGORY_CELL_IDENTIFIER];
     [self.contentCollection registerNib:[UINib nibWithNibName:@"LoadingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:LOADING_CELL_IDENTIFIER];
    
    currentPage = @(0);
    hairfies = [[NSMutableArray alloc] init];
    endOfScroll = NO;
    [self getHairfies:nil];
    
    categoriesNames = [[NSArray alloc] initWithObjects:@"FEMME",@"HOMME",@"BARBIER",@"MARIAGE",@"COLORATION", nil];
    
    categoriesImages = [[NSArray alloc] initWithObjects:@"woman-category.png",@"man-category.png",@"barber-category.png",@"marriage-category.png",@"color-category.png", nil];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:self.menuItemSelected
                          
                                                     forKey:@"menuItem"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionChanged"
                                                        object:self
                                                      userInfo:dict];
}

-(void)viewWillAppear:(BOOL)animated
{
   
    NSLog(@"menu item %@", self.menuItemSelected);
    [self.contentCollection reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.menuItemSelected isEqualToString:@"Hairfies"]) {
        if (indexPath.row < [hairfies count]) {
            return CGSizeMake((collectionView.frame.size.width - 30) / 2, 210);
        } else {
            return CGSizeMake(collectionView.frame.size.width, 58);
        }
    }
    else  if ([self.menuItemSelected isEqualToString:@"Réserver"]){
        return CGSizeMake(collectionView.frame.size.width - 30, 100);
    }
    else
        return CGSizeMake(100, 100);
    
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if ([self.menuItemSelected isEqualToString:@"Hairfies"])
        return [hairfies count] + 1;
    else  if ([self.menuItemSelected isEqualToString:@"Réserver"])
        return [categoriesNames count];
    else
        return 1;
}

// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 5;
}


// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.menuItemSelected isEqualToString:@"Hairfies"]) {
        if (indexPath.row < [hairfies count]) {
            
            if(indexPath.row == ([hairfies count] - HAIRFIES_PAGE_SIZE + 1)){
                [self fetchMoreHairfies];
            }
            
            return [self hairfieCellForIndexPath:indexPath];
        } else {
            return [self loadingCellForIndexPath:indexPath];
        }
    }
    else  if ([self.menuItemSelected isEqualToString:@"Réserver"]) {
        return [self categoryCellForIndexPath:indexPath];
    }
    else
        return nil;
}

- (UICollectionViewCell *)categoryCellForIndexPath:(NSIndexPath *)indexPath{
    
    CategoriesCollectionViewCell *cell = [self.contentCollection dequeueReusableCellWithReuseIdentifier:CATEGORY_CELL_IDENTIFIER forIndexPath:indexPath];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CategoriesCollectionViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    [cell setupCellWithName:[categoriesNames objectAtIndex:indexPath.item] andImage:[UIImage imageNamed:[categoriesImages objectAtIndex:indexPath.item]]];
    
    return cell;
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



// Get Hairfies Data

-(void)getHairfies:(NSNumber *)page
{
    if(page == nil) {
        page = @(0);
    }
    NSNumber *offset = @([page integerValue] * HAIRFIES_PAGE_SIZE);
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on load %@", error.description);
       // [refreshControl endRefreshing];
    };
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models){
        if([models count] < HAIRFIES_PAGE_SIZE) endOfScroll = YES;
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
    NSLog(@"FETCHING MORE HAIRFIES ******************");
    int value = [currentPage intValue];
    currentPage = [NSNumber numberWithInt:value + 1];;
    [self getHairfies:currentPage];
}


- (void)customReloadData
{
    [self.contentCollection reloadData];
//    if (refreshControl) {
//        [refreshControl endRefreshing];
//    }
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
