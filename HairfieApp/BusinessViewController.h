//
//  BusinessViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 11/24/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business.h"

@interface BusinessViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) Business *business;

@property (nonatomic) IBOutlet UIButton *leftMenuBttn;
@property (nonatomic) IBOutlet UIButton *navBttn;
@property (nonatomic) IBOutlet UIButton *bottomMenuBttn;



@end
