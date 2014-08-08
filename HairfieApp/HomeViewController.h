//
//  HomeViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 28/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLEContainerScrollView.h"

@interface HomeViewController : UIViewController <UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic) IBOutlet UILabel *AroundMeLabel;
@property (nonatomic) IBOutlet UICollectionView *hairfieCollection;
@property (nonatomic) IBOutlet UIView *topView;
@property (nonatomic) IBOutlet OLEContainerScrollView *test;


@end
