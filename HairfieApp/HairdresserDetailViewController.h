//
//  HairdresserDetailViewController.h
//  HairfieApp
//
//  Created by Leo Martin on 11/25/14.
//  Copyright (c) 2014 Hairfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hairdresser.h"
#import "Business.h"

@interface HairdresserDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) Hairdresser *hairdresser;
@property (nonatomic) Business *business;

@end
