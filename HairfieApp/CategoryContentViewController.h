//
//  CategoryContentViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 1/13/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryContentViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property NSUInteger pageIndex;

@property (nonatomic) IBOutlet UICollectionView *contentCollection;

@end
