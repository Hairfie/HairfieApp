//
//  LikeViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 29/07/2014.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hairfie.h"

@interface LikeViewController : UIViewController <UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    IBOutlet UIView *myView;
}

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@end