//
//  CategoryContentViewController.m
//  HairfieApp
//
//  Created by Leo Martin on 1/13/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import "CategoryContentViewController.h"
#import "CategoriesCollectionViewCell.h"

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
    categoriesNames = [[NSArray alloc] initWithObjects:@"FEMME",@"HOMME",@"BARBIER",@"MARIAGE",@"COLORATION", nil];
    
    categoriesImages = [[NSArray alloc] initWithObjects:@"woman-category.png",@"man-category.png",@"barber-category.png",@"marriage-category.png",@"color-category.png", nil];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:@"Réserver"
                          
                                                     forKey:@"menuItem"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionChanged"
                                                        object:self
                                                      userInfo:dict];

}
-(void)viewWillAppear:(BOOL)animated
{
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width - 30, 100);
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return [categoriesNames count];
}

// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}


// 3
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

     //       NSUInteger selectedRow = indexPath.row;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"searchFromFeed" object:self];
           
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
