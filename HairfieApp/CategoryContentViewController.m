//
//  CategoryContentViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 1/13/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "CategoryContentViewController.h"
#import "CategoriesCollectionViewCell.h"
#import "BusinessSearch.h"

@interface CategoryContentViewController ()

@end

@implementation CategoryContentViewController
{
    NSArray *categoriesNames;
    NSArray *categoriesImages;
}

#define CATEGORY_CELL_IDENTIFIER @"categoryCell"

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.contentCollection registerNib:[UINib nibWithNibName:@"CategoriesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CATEGORY_CELL_IDENTIFIER];
    
    
    categoriesNames = [[NSArray alloc] initWithObjects:NSLocalizedStringFromTable(@"women hairdresser", @"Feed", nil),NSLocalizedStringFromTable(@"men hairdresser", @"Feed", nil), nil];
    categoriesImages = [[NSArray alloc] initWithObjects:@"woman-category.png",@"man-category.png", nil];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:NSLocalizedStringFromTable(@"Book",@"Feed",nil)
                                                     forKey:@"menuItem"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionChanged"
                                                        object:self
                                                      userInfo:dict];
    [self.contentCollection reloadData];

}
-(void)viewWillAppear:(BOOL)animated {
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.frame.size.width - 30, 100);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [categoriesNames count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self categoryCellForIndexPath:indexPath];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BusinessSearch *businessSearch = [[BusinessSearch alloc] init];

    if (indexPath.row == 1) {
         NSArray *clientTypes = [NSArray arrayWithObjects:@"women", nil];
         businessSearch.clientTypes = clientTypes;
    } else if (indexPath.row == 2) {
        NSArray *clientTypes = [NSArray arrayWithObjects:@"men", nil];
        businessSearch.clientTypes = clientTypes;
    }
   
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:businessSearch, @"businessSearch", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchFromFeed" object:nil userInfo:dic];
}

@end
