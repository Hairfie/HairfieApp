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
#import "HairfieDetailViewController.h"

@interface LikeViewController ()

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
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = [delegate currentUser];
    
    [User listHairfiesLikedByUser:currentUser.id
                            limit:@10
                             skip:@0
                          success:^(NSArray *hairfies) {
                              self.hairfies = hairfies;
                              [self.collectionView reloadData];
                          }
                          failure:^(NSError *error) {
                              NSLog(@"Failed to retrieve liked hairfies: %@", error.localizedDescription);
                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Hello");
    [self performSegueWithIdentifier:@"hairfieDetail" sender:self.hairfies[indexPath.row]];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hairfies.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hairfieCell"
                                                                           forIndexPath:indexPath];
    
    [cell setHairfie:self.hairfies[indexPath.row]];
    
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
