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
#import "SearchCategory.h"
#import "AppDelegate.h"

@interface CategoryContentViewController ()

@end

@implementation CategoryContentViewController
{
    NSArray *categories;
}

#define CATEGORY_CELL_IDENTIFIER @"categoryCell"

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.contentCollection registerNib:[UINib nibWithNibName:@"CategoriesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CATEGORY_CELL_IDENTIFIER];
    
    [self getCategories:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getCategories:)
                                                 name:@"getCategories"
                                               object:nil];
    
    // Do any additional setup after loading the view.
}

- (void) getCategories:(NSNotification *) notification {
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    categories = [delegate categories];
    [self.contentCollection reloadData];
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
    return [categories count];
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
    
    [cell setupWithCategory:[categories objectAtIndex:indexPath.item]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BusinessSearch *businessSearch = [[BusinessSearch alloc] init];
    businessSearch.categories = [NSArray arrayWithObjects:[categories objectAtIndex:indexPath.item], nil];
   
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:businessSearch, @"businessSearch", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchFromFeed" object:nil userInfo:dic];
}

@end
