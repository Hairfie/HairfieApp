//
//  HairfieContentViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 1/12/15.
//  Copyright (c) 2015 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HairfieContentViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property NSUInteger pageIndex;

@property (nonatomic) NSString *menuItemSelected;
@property (nonatomic) IBOutlet UICollectionView *contentCollection;

@end
